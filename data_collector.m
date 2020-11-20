function [standingUp_time,RMS_distance_ap,RMS_distance_ml,total_cop_path,mean_velocity,NPL,Gtotal,Gtotal_timetable,grip_strength,jaw_clench]= data_collector(port,baudrate)
    s = serialport(port,baudrate);
    configureTerminator(s,"CR"); %Configure serial port connection
    x = 0; %Matrice index row variable
    increment = true;
    collected_data = zeros(1000,10);
    run = true
    while run
      bytes = s.NumBytesAvailable; %Return how many bytes available from serial port
      while bytes <0
           timestamps = collected_data(1:x,10:10);
           [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity] = cop_calculator([collected_data(1:x,1:4),timestamps],startSmooth,startSaccadic);
           [Gtotal,NPL,Gtotal_timetable] = NPL_Calculator([collected_data(1:x,5:7),timestamps]);
           [grip_strength] = grip_strength_calculator([collected_data(1:x,8:8),timestamps]);
           [jaw_clench] = jaw_clench([collected_data(1:x,9:9),timestamps]);
           run = false; % stop collecting the data.
           
      end
      
     x = x + 1; %increment index variable
    
    data = readline(s); %Read line or data from Arduino

    newStr = split(data,",",1); %Splits collected line with data (F1,F2,F3,F4,GX,GY,GZ,ARM1,ARM2,GRIP,JAW,timestamp)
    
    collected_data(x,:) = str2double( newStr ); %calling the last row of data, to convert strings to double
    
      
    %Extends matrice if matrice is full
    if x == 1000
    
    collected_data = wextend('addrow','zpd',collected_data(:,:,i),1000,'d');    
    
    x = 1; %Resets index counter
    
    end
    

    pause(0.05); %Pause betwen reading each line. Or else systems reads to fast versus how fast data can be sent from Arduino
    
    end
        
    