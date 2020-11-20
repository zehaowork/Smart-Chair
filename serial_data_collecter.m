

function collected_data = serial_data_collecter(COM_PORT,baudrate)

run = true; 
s = serialport(COM_PORT,baudrate); %Create serial port connection with Arduino
configureTerminator(s,"CR"); %Configure serial port connection
x = 0; %Matrice index row variable
i = 1; %Matrice index "3-rd" dimension variable
counter = 1; %Number of data sets collected
increment = true;
collected_data = zeros(1000,10,i); %Empty matrice for collected datapoints read from serial port
key_value = zeros(100,5); 
while run

    bytes = s.NumBytesAvailable; %Return how many bytes available from serial port
    
    % after each each session finishes
    while bytes <= 0 %While no bytes available
     
        if counter > 1 && increment == false %When data points collected
            
            disp(counter);
            
            %Analyse datapoints collected and return key values
            [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity] = cop_calculator(collected_data(1:x-1,:,i),startSmooth,startSaccadic);
            
            %Save key values in matrice for comparsion
            key_value(i,1) = standingUp_time;
            key_value(i,2) = RMS_distance_ap;
            key_value(i,3) = RMS_distance_ml;
            key_value(i,4) = total_cop_path;
            key_value(i,5) = mean_velocity(1,1);
            
            disp(key_value(1:i,:));

            
            
            %Simple rating index. Where lowest score is 0, highest score is
            %i*2-1. Due to Arduino struggeling to read negative numbers
            %lowest index is 0.
            standingUp_index = i-1;
            RMSdistance_ap_index = i-1;
            RMSdistance_ml_index = i-1;
            totCoP_path_index = i-1;
            mean_velocity_index = i-1;
            
            %Calculate index ( comparing new key values with previous
            %values)
            for a = 1:i-1
            
            if ( key_value(a,1) > key_value(i,1) ) , standingUp_index = standingUp_index +1;
            elseif ( key_value(a,1) < key_value(i,1) ) , standingUp_index = standingUp_index - 1;
                %write(s,standingUp_index,"int8");
            end
            
            if (  key_value(a,2) > key_value(i,2) ) , RMSdistance_ap_index = RMSdistance_ap_index + 1;
            elseif (  key_value(a,2) < key_value(i,2) ) , RMSdistance_ap_index = RMSdistance_ap_index - 1;
                %write(s,RMSdistance_ap_index,"int8");
            end
            
            if (  key_value(a,3) > key_value(i,3) ) , RMSdistance_ml_index = RMSdistance_ml_index + 1;
            elseif (  key_value(a,3) < key_value(i,3) ) , RMSdistance_ml_index = RMSdistance_ml_index - 1;
                %write(s,RMSdistance_ml_index,"int8");
            end
            
            if (  key_value(a,4) > key_value(i,4) ) , totCoP_path_index = totCoP_path_index + 1;
            elseif (  key_value(a,4) < key_value(i,4) ) , totCoP_path_index = totCoP_path_index - 1;
                
            end
            
            if ( key_value(a,5) > key_value(i,5) ) , mean_velocity_index = mean_velocity_index + 1;
            elseif (  key_value(a,5) < key_value(i,5) ) , mean_velocity_index = mean_velocity_index - 1;
                %write(s,mean_velocity_index,"int8");
            end
            
            end         
            
            %Set datatype of index values to int8.
            score = int8(i-1);
            standingUp_index = int8(standingUp_index);
            RMSdistance_ap_index = int8(RMSdistance_ap_index);
            RMSdistance_ml_index = int8(RMSdistance_ml_index);
            totCoP_path_index = int8(totCoP_path_index);
            mean_velocity_index = int8(mean_velocity_index);
            
            
            %Send data to Arduino
            write(s,score,"int8")
            pause(0.1);
            write(s,standingUp_index,"int8")
            pause(0.1);
            write(s,RMSdistance_ap_index,"int8")
            pause(0.1);
            write(s,RMSdistance_ml_index,"int8")
            pause(0.1);
            write(s,totCoP_path_index,"int8")
            pause(0.1);
            write(s,mean_velocity_index,"int8")
           
            i = i +1;
            increment = true;
        end
        
        %Check is bytes available
        bytes = s.NumBytesAvailable;
        
        x=1;
        
    end
    
    %One increment for each data set collected
    if increment == true
        
        increment = false;
        counter = counter + 1;
        
    end
    x = x + 1; %increment index variable
    
    data = readline(s); %Read line or data from Arduino

    newStr = split(data,",",1); %Splits collected line with data (F1,F2,F3,F4,timestamp)

    collected_data(x,:,i) = str2double( newStr ); %Transform string to double and saves if matrice

    %If clock index is = 1 is the end of serial data transmission. 
    if collected_data(x,5,i) == 1
        
        flush(s); %Removed data from input buffer
        bytes = 0; %Resets byte value to zero
        startSmooth = collected_data(x,1,i); %Send matrice index for when smooth pursuit eye movement started.
        startSaccadic = collected_data(x,2,i); %Sends matrice index for when saccadic eye movement started.
        collected_data(x,:,i) = 0; %Delete last line of data as it is not datapoints.

        disp('Catch end'); %End of series data collection.
    end 
    
    %Extends matrice if matrice is full
    if x == 1000
    
    collected_data = wextend('addrow','zpd',collected_data(:,:,i),1000,'d');    
    
    x = 1; %Resets index counter
    
    end
    

    pause(0.05); %Pause betwen reading each line. Or else systems reads to fast versus how fast data can be sent from Arduino
    
end

end