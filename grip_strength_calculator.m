function [grip_strength] = grip_strength_calculator(data)
 time = ( data(:,2) / 1000 );
 grip_strength =   timetable(data(1,1), 'RowTimes', time);