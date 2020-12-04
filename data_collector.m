function  [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity]= data_collector(port,baudrate)
    s = serialport(port,baudrate);
    configureTerminator(s,"CR"); %Configure serial port connection
    x = 0; %Matrice index row variable
    %increment = true;
    collected_data = zeros(100,10);
    run = true;
    while run
      %bytes = s.NumBytesAvailable; %Return how many bytes available from serial port
      if x > 100
           timestamps = collected_data(1:x,10);
           jaw_clench_readings = collected_data(1:x,8);
            jaw_clench([jaw_clench_readings;timestamps])
           load_cells = collected_data(1:x,1:4);
           [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity] = cop_calculator([load_cells;timestamps]);
           run = false; % stop collecting the data.
           
      end
    
    data = readline(s); %Read line or data from Arduino
    disp(data);

    newStr = split(data,",",1); %Splits collected line with data (F1,F2,F3,F4,GX,GY,GZ,ARM1,ARM2,GRIP,JAW,timestamp)
    
    x = x + 1;
    
    collected_data(x,:) = str2double( newStr ); %calling the last row of data, to convert strings to double
    
      
    %Extends matrice if matrice is full
    %if x == 1000
    %
    %collected_data = wextend('addrow','zpd',collected_data(:,:,i),1000,'d');    
    %
    %x = 1; %Resets index counter
    %
    %end
    

    pause(0.05); %Pause betwen reading each line. Or else systems reads to fast versus how fast data can be sent from Arduino
    
    end
        
    