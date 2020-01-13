function [y] = decoder(input_flac)
 id = fopen(input_flac,'r');
 input_data=[];
 input_data= fscanf(id,'%s');

 k = dec2bin(input_data,8);
 k = k(:,7:end);
 j=[];
 counter =1;
 for i=1:length(k)
    j = [j k(i,:)];
 end
 
 if(~(strcmp(j(1,1:32),'01100110010011000110000101000011')))
   return;
 else
     % Metadata Block Header
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     counter = 33;
     if( j(1,counter) ~= '1') %Checking for last metadata block
        return
     end
     counter = counter + 1;
     if( j(1,counter:counter+6) ~= '0000000') %Checking for metadatablock type
         return
     end
     counter =counter + 7;
     meta_length = j(1,counter:counter+23);
     counter = counter +24;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Metadata Block Streaminfo
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     min_block_size = j(1,counter:counter+15);
     counter = counter+16;
     max_block_size = j(1,counter:counter+15);
     counter = counter+16;
     min_frame_size = '000000000000000000000000'; %Framze size given zero in input file
     max_frame_size = '000000000000000000000000';
     counter = counter +48;
     sample_rate = j(1,counter:counter+19);
     counter = counter+20;
     num_channels = j(1,counter:counter+2);
     counter = counter+3;
     bits_per_sample = j(1,counter:counter+4);
     counter = counter+5;
     total_samples = j(1,counter:counter+35);
     counter = counter+36;
     md5 = j(1,counter:counter+127);
     counter = counter+128;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %Frame
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     counter=counter+32;
        %to skip utf8 bits
         temp= j(1,counter:counter+7);
         temp1 =bin2dec(temp);
         var = bin2dec('11111111') %0xFF
            while (temp1>=bin2dec('11000000'))
                counter = counter+8;
                temp1 = bitand(bitsll(1,temp1),var);
            end
      counter = counter +8;% skip 8 crc bits
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %subframe
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    counter = counter+8;% 6 bits are for switching subframe type
    result = j(1,counter:counter+63);% 64 = 16 * 4 
    counter = counter + 64;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %rice decode
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    residual_signal = [];
    counter = counter +2;% residual coding method
    counter = counter +4;%partition order
    parameter = j(1,counter:counter+4);%5 bits for rice parameter
    num_samples_part = 4092;
    high_order_bits =0;
    low_order_bits =0;
        while num_samples_part >0
            num_samples_part= num_samples_part-1;
            while j(1,counter) == 0
                counter = counter +1;
                high_order_bits =high_order_bits+1; 
            end    
                high_order_bits = dec2bin(high_order_bits);
                counter = counter +1;
                low_order_bits =j(1,counter:counter+parameter -1);
                low_order_bits= num2str(low_order_bits);
                low_order_bits(isspace(low_order_bits)) = '';
                sample_bits = [high_order_bits low_order_bits];
                mapped_sample = bin2dec(sample_bits);
                
                if(rem(mapped_sample,2)==0)
                    sample = mapped_sample/2;
                else 
                    sample = -((mapped_sample+1)/2);
                    
                end
                residual_signal = [residual_signal sample];
        end
                
 end
 
 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Fixed LPC Decoder
   
   %signal = [3 7 8 5 4 9 16 23 2 8 5 6 5 7 7 1]; 
   fixedArrCoeff = [4 -6 4 -1];                    % fixed order 4 co-efficients
   orig_samp = [3 7 8 5];
   %residual = [7 -2 -8 2 -26 83 -91 49 -19 11 -10 1]; 

   order = 4;    % lpc order  
   length = 4096;  % frame size
   k = 1;

   for i = order+1:length
       disp(orig_samp);
       pred_samp = 0;
       for j = 1:1:4
           pred_samp = pred_samp + fixedArrCoeff(j)*orig_samp(4+k-j);
           %disp(pred_samp);
       end
       %disp(pred_samp);
       %disp(residual((i + 12) - 16));
       pred_samp = pred_samp + residual_signal((i + 4092) - 4096);
       orig_samp = [orig_samp , pred_samp]
       %disp(orig_samp);
       k = k + 1;
   end 
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
 %min_blk_size = input_data(1,1:4)
end