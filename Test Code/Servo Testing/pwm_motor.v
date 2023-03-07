module  pwm_motor ( 

    input clk ,
    output LEFT_SERVO ,
    output GRIPPER_SERVO 

) ;


// for 1 ms ----> 50,000
// for x ms ----> 50,000 * x 

// Total time period of pulse is 20ms ---> 50,000 * 20 == 100,0000

// up-down:- default = 118000, up - 135000
// postions:-  default = 65000, close = 15000 , open = 115000

reg left_servo = 0 ;
assign LEFT_SERVO = left_servo ;

reg gripper_servo = 0 ;
assign GRIPPER_SERVO = gripper_servo ;

reg [20:0] pwm_counter  = 0 ;
reg [5:0]  delay_count  = 0 ;

reg  flag_up_servo     = 0 ; 
reg  flag_down_servo   = 1 ;
reg  flag_close_servo  = 0 ;
reg  flag_open_servo   = 0 ;
reg  flag_wait_counter = 0 ;
reg  flag_one_time_servo = 0 ;
 

always @ ( posedge clk )
begin

// 1. down arm 
// 2. to open gripper 
// 3. wait for sometime 
// 4. close  gripper 
// 5. up gripper 



// down gripper 
if (flag_down_servo == 1)
begin

    if (pwm_counter <= 118000 ) 
    begin
        left_servo = 1 ;
        flag_one_time_servo = 1 ;
    end

    if (pwm_counter >118000 ) 
    begin 
        
        left_servo = 0 ;
        
        if (flag_one_time_servo == 1 )
        begin
            delay_count = delay_count + 1  ;
            flag_one_time_servo = 0 ;
        end

        if (delay_count == 10 )
        begin
            delay_count = 0 ;
            flag_down_servo = 0 ;
				flag_open_servo = 1;
				
//            flag_wait_counter = 1 ;
        end
    end   

end 



// open gripper 
if (flag_open_servo == 1)
begin

    if (pwm_counter <=115000 ) 
    begin
        gripper_servo = 1 ;
        flag_one_time_servo = 1 ;
    end

    if (pwm_counter > 115000 ) 
    begin 
        
        gripper_servo = 0 ;
        
        if (flag_one_time_servo == 1 )
        begin
            delay_count = delay_count + 1  ;
            flag_one_time_servo = 0 ;
        end

        if (delay_count == 10 )
        begin
            delay_count = 0; 
            flag_open_servo = 0 ;
            flag_wait_counter = 1 ;
//				flag_one_time_servo = 1 ;
        end
    end   
end 



// wait 
if (flag_wait_counter == 1)
begin

    if (pwm_counter <=1000  )
    begin
        flag_one_time_servo = 1 ;
    end

    if (pwm_counter > 1000)
    begin
        
        if (flag_one_time_servo == 1)
        begin
            delay_count = delay_count +1 ;
            flag_one_time_servo = 0 ;
        end
        
        if (delay_count == 10 )
        begin
            delay_count = 0 ;
            flag_wait_counter = 0 ;
            flag_close_servo = 1; 
        end 

    end

end 



// close gripper 
if (flag_close_servo == 1)
begin

    if (pwm_counter <= 15000) 
    begin
        gripper_servo = 1 ;
        flag_one_time_servo = 1 ;
    end

    if (pwm_counter > 15000) 
    begin 
        
        gripper_servo = 0 ;
        
        if (flag_one_time_servo == 1 )
        begin
            delay_count = delay_count + 1  ;
            flag_one_time_servo = 0 ;
        end

        if (delay_count == 10 )
        begin
            delay_count = 0 ;
            flag_close_servo = 0 ;
            flag_up_servo = 1 ;
        end
    end   
end 



// up servo  
if (flag_up_servo == 1)
begin

    if (pwm_counter <= 135000) 
    begin
        left_servo = 1 ;
        flag_one_time_servo = 1 ;
    end

    if (pwm_counter > 135000 ) 
    begin 
        
        left_servo = 0 ;
        
        if (flag_one_time_servo == 1 )
        begin
            delay_count = delay_count + 1  ;
            flag_one_time_servo = 0 ;
        end

        if (delay_count == 10 )
        begin
            delay_count = 0 ;
            flag_up_servo = 0 ;
            flag_down_servo = 1 ;
        end
    end   

end 



if (pwm_counter == 1000000 )
begin
    pwm_counter = 0 ;
end 
pwm_counter = pwm_counter + 1 ;


end 
endmodule 