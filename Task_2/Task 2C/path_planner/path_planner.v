// SM : Task 2 C : Path Planning
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design path planner.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Path Planner design
//Parameters : node_count : for total no. of nodes + 1 (consider an imaginary node, refer discuss forum),
//					max_edges : no. of max edges for every node.


//Inputs  	 : clk : 50 MHz clock, 
//				   start : start signal to initiate the path planning,
//				   s_node : start node,
//				   e_node : destination node.
//
//Output     : done : Path planning completed signal,
//             final_path : the final path from start to end node.



//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////

module path_planner
#(parameter node_count = 27, parameter max_edges = 4)
(
	input clk,
	input start,
	input [4:0] s_node,
	input [4:0] e_node,
	output reg done,	
	output reg [10*5-1:0] final_path
);

////////////////////////WRITE YOUR CODE FROM HERE////////////////////

// --- Declaration ---

reg [6:0] distance_from_starting_node[26:0] ; // array to store distance of a node from starting node 
reg [1:0] status_flag[26:0] ;                 // array to store if node is visited or not 
reg [4:0] adjacent_nodes[25:0][3:0] ;         // array to store connected nodes 
reg [3:0] path_of_adjacent_nodes[25:0][3:0] ; // array to store connected nodes length 
reg [4:0] previous_node[26:0] ;               // array to store previous node 

reg [6:0]  inf = 100 ; 
reg [4:0]  counter = 5'b0 ;         // max count 30 
reg [6:0]  least_value = 100 ;     
reg [4:0]  hopper = 27 ;

reg [1:0] counter_working      ;        
reg [1:0] list_update_working  ;        // flags to enable and disable particular section of a code
reg [1:0] trace_path_working   ;

reg [1:0] print_working  ;
reg [1:0] print_working_initial  ;

reg [49:0] previous_path = 27 ; 
reg [49:0] Final_Path = 50'b11011110111101111011110111101111011110111101111011 ;
reg [10:0] main_counter = 11'b0 ; //11'b11001110010    // 11001110010
reg [1:0]  activate_main_loop = 0 ;
reg  done_flag = 1'b0 ;
reg [1:0] activate_update_loop = 1'b0 ;

// --- xxx --- 

// --- Path Storage and Initial Declaractions ---

initial 
begin 
adjacent_nodes[0][0] = 1; adjacent_nodes[0][1] = 26; adjacent_nodes[0][2] = 26; adjacent_nodes[0][3] = 26;
path_of_adjacent_nodes[0][0] = 3; path_of_adjacent_nodes[0][1] = inf ; path_of_adjacent_nodes[0][2] = inf ; path_of_adjacent_nodes[0][3] = inf ;

adjacent_nodes[1][0] = 0; adjacent_nodes[1][1] = 13; adjacent_nodes[1][2] = 2; adjacent_nodes[1][3] = 26;
path_of_adjacent_nodes[1][0] = 3; path_of_adjacent_nodes[1][1] = 3; path_of_adjacent_nodes[1][2] = 3; path_of_adjacent_nodes[1][3] = inf ;

adjacent_nodes[2][0] = 1; adjacent_nodes[2][1] = 3; adjacent_nodes[2][2] = 5; adjacent_nodes[2][3] = 26;
path_of_adjacent_nodes[2][0] = 3; path_of_adjacent_nodes[2][1] = 1; path_of_adjacent_nodes[2][2] = 3; path_of_adjacent_nodes[2][3] = inf ;

adjacent_nodes[3][0] = 2; adjacent_nodes[3][1] = 26; adjacent_nodes[3][2] = 26; adjacent_nodes[3][3] = 26;
path_of_adjacent_nodes[3][0] = 1; path_of_adjacent_nodes[3][1] = inf ; path_of_adjacent_nodes[3][2] = inf; path_of_adjacent_nodes[3][3] = inf ;

adjacent_nodes[4][0] = 6; adjacent_nodes[4][1] = 26; adjacent_nodes[4][2] = 26; adjacent_nodes[4][3] = 26;
path_of_adjacent_nodes[4][0] = 3; path_of_adjacent_nodes[4][1] = inf; path_of_adjacent_nodes[4][2] = inf; path_of_adjacent_nodes[4][3] = inf;

adjacent_nodes[5][0] = 2; adjacent_nodes[5][1] = 6; adjacent_nodes[5][2] = 9; adjacent_nodes[5][3] = 26;
path_of_adjacent_nodes[5][0] = 3; path_of_adjacent_nodes[5][1] = 1; path_of_adjacent_nodes[5][2] = 2; path_of_adjacent_nodes[5][3] = inf;

adjacent_nodes[6][0] = 4; adjacent_nodes[6][1] = 16; adjacent_nodes[6][2] = 5; adjacent_nodes[6][3] = 26;
path_of_adjacent_nodes[6][0] = 3; path_of_adjacent_nodes[6][1] = 3; path_of_adjacent_nodes[6][2] = 1; path_of_adjacent_nodes[6][3] = inf;

adjacent_nodes[7][0] = 12; adjacent_nodes[7][1] = 26; adjacent_nodes[7][2] = 26; adjacent_nodes[7][3] = 26;
path_of_adjacent_nodes[7][0] = 2; path_of_adjacent_nodes[7][1] = inf; path_of_adjacent_nodes[7][2] = inf; path_of_adjacent_nodes[7][3] = inf;

adjacent_nodes[8][0] = 9; adjacent_nodes[8][1] = 26; adjacent_nodes[8][2] = 26; adjacent_nodes[8][3] = 26;
path_of_adjacent_nodes[8][0] = 1; path_of_adjacent_nodes[8][1] = inf; path_of_adjacent_nodes[8][2] = inf; path_of_adjacent_nodes[8][3] = inf;

adjacent_nodes[9][0] = 5; adjacent_nodes[9][1] = 15; adjacent_nodes[9][2] = 8; adjacent_nodes[9][3] = 26;
path_of_adjacent_nodes[9][0] = 2; path_of_adjacent_nodes[9][1] = 1; path_of_adjacent_nodes[9][2] = 1; path_of_adjacent_nodes[9][3] = inf;

adjacent_nodes[10][0] = 16; adjacent_nodes[10][1] = 26; adjacent_nodes[10][2] = 26; adjacent_nodes[10][3] = 26;
path_of_adjacent_nodes[10][0] = 2; path_of_adjacent_nodes[10][1] = inf; path_of_adjacent_nodes[10][2] = inf; path_of_adjacent_nodes[10][3] = inf;

adjacent_nodes[11][0] = 12; adjacent_nodes[11][1] = 26; adjacent_nodes[11][2] = 26; adjacent_nodes[11][3] = 26;
path_of_adjacent_nodes[11][0] = 3; path_of_adjacent_nodes[11][1] = inf; path_of_adjacent_nodes[11][2] = inf; path_of_adjacent_nodes[11][3] = inf;

adjacent_nodes[12][0] = 7; adjacent_nodes[12][1] = 11; adjacent_nodes[12][2] = 17; adjacent_nodes[12][3] = 13;
path_of_adjacent_nodes[12][0] = 2; path_of_adjacent_nodes[12][1] = 3; path_of_adjacent_nodes[12][2] = 3; path_of_adjacent_nodes[12][3] = 1;

adjacent_nodes[13][0] = 1; adjacent_nodes[13][1] = 12; adjacent_nodes[13][2] = 18; adjacent_nodes[13][3] = 26;
path_of_adjacent_nodes[13][0] = 3; path_of_adjacent_nodes[13][1] = 1; path_of_adjacent_nodes[13][2] = 2; path_of_adjacent_nodes[13][3] = inf;

adjacent_nodes[14][0] = 15; adjacent_nodes[14][1] = 26; adjacent_nodes[14][2] = 26; adjacent_nodes[14][3] = 26;
path_of_adjacent_nodes[14][0] = 1; path_of_adjacent_nodes[14][1] = inf; path_of_adjacent_nodes[14][2] = inf; path_of_adjacent_nodes[14][3] = inf;

adjacent_nodes[15][0] = 14; adjacent_nodes[15][1] = 9; adjacent_nodes[15][2] = 22; adjacent_nodes[15][3] = 26;
path_of_adjacent_nodes[15][0] = 1; path_of_adjacent_nodes[15][1] = 1; path_of_adjacent_nodes[15][2] = 1; path_of_adjacent_nodes[15][3] = inf;

adjacent_nodes[16][0] = 6; adjacent_nodes[16][1] = 10; adjacent_nodes[16][2] = 23; adjacent_nodes[16][3] = 26;
path_of_adjacent_nodes[16][0] = 3; path_of_adjacent_nodes[16][1] = 2; path_of_adjacent_nodes[16][2] = 2; path_of_adjacent_nodes[16][3] = inf;

adjacent_nodes[17][0] = 12; adjacent_nodes[17][1] = 26; adjacent_nodes[17][2] = 26; adjacent_nodes[17][3] = 26;
path_of_adjacent_nodes[17][0] = 3; path_of_adjacent_nodes[17][1] = inf; path_of_adjacent_nodes[17][2] = inf; path_of_adjacent_nodes[17][3] = inf;

adjacent_nodes[18][0] = 13; adjacent_nodes[18][1] = 19; adjacent_nodes[18][2] = 20; adjacent_nodes[18][3] = 26;
path_of_adjacent_nodes[18][0] = 2; path_of_adjacent_nodes[18][1] = 1; path_of_adjacent_nodes[18][2] = 1; path_of_adjacent_nodes[18][3] = inf;

adjacent_nodes[19][0] = 18; adjacent_nodes[19][1] = 26; adjacent_nodes[19][2] = 26; adjacent_nodes[19][3] = 26;
path_of_adjacent_nodes[19][0] = 1; path_of_adjacent_nodes[19][1] = inf; path_of_adjacent_nodes[19][2] = inf; path_of_adjacent_nodes[19][3] = inf;

adjacent_nodes[20][0] = 18; adjacent_nodes[20][1] = 21; adjacent_nodes[20][2] = 22; adjacent_nodes[20][3] = 26;
path_of_adjacent_nodes[20][0] = 1; path_of_adjacent_nodes[20][1] = 1; path_of_adjacent_nodes[20][2] = 2; path_of_adjacent_nodes[20][3] = inf;

adjacent_nodes[21][0] = 20; adjacent_nodes[21][1] = 26; adjacent_nodes[21][2] = 26; adjacent_nodes[21][3] = 26;
path_of_adjacent_nodes[21][0] = 1; path_of_adjacent_nodes[21][1] = inf; path_of_adjacent_nodes[21][2] = inf; path_of_adjacent_nodes[21][3] = inf;

adjacent_nodes[22][0] = 15; adjacent_nodes[22][1] = 25; adjacent_nodes[22][2] = 23; adjacent_nodes[22][3] = 20;
path_of_adjacent_nodes[22][0] = 1; path_of_adjacent_nodes[22][1] = 3; path_of_adjacent_nodes[22][2] = 1; path_of_adjacent_nodes[22][3] = 2;

adjacent_nodes[23][0] = 22; adjacent_nodes[23][1] = 24; adjacent_nodes[23][2] = 16; adjacent_nodes[23][3] = 26;
path_of_adjacent_nodes[23][0] = 1; path_of_adjacent_nodes[23][1] = 2; path_of_adjacent_nodes[23][2] = 2; path_of_adjacent_nodes[23][3] = inf;

adjacent_nodes[24][0] = 23; adjacent_nodes[24][1] = 26; adjacent_nodes[24][2] = 26; adjacent_nodes[24][3] = 26;
path_of_adjacent_nodes[24][0] = 2; path_of_adjacent_nodes[24][1] = inf; path_of_adjacent_nodes[24][2] = inf; path_of_adjacent_nodes[24][3] = inf;

adjacent_nodes[25][0] = 22; adjacent_nodes[25][1] = 26; adjacent_nodes[25][2] = 26; adjacent_nodes[25][3] = 26;
path_of_adjacent_nodes[25][0] = 3; path_of_adjacent_nodes[25][1] = inf; path_of_adjacent_nodes[25][2] = inf; path_of_adjacent_nodes[25][3] = inf;



distance_from_starting_node[0]  = 100 ; status_flag[0] =  0 ;  previous_node[0] = 27 ; 
distance_from_starting_node[1]  = 100 ; status_flag[1] =  0 ;  previous_node[1] = 27 ; 
distance_from_starting_node[2]  = 100 ; status_flag[2] =  0 ;  previous_node[2] = 27; 
distance_from_starting_node[3]  = 100 ; status_flag[3] =  0 ;  previous_node[3] = 27 ; 
distance_from_starting_node[4]  = 100 ; status_flag[4] =  0 ;  previous_node[4] = 27 ; 
distance_from_starting_node[5]  = 100 ; status_flag[5] =  0 ;  previous_node[5] = 27 ; 
distance_from_starting_node[6]  = 100 ; status_flag[6] =  0 ;  previous_node[6] = 27 ; 
distance_from_starting_node[7]  = 100 ; status_flag[7] =  0 ;  previous_node[7] = 27 ; 
distance_from_starting_node[8]  = 100 ; status_flag[8] =  0 ;  previous_node[8] = 27 ; 
distance_from_starting_node[9]  = 100 ; status_flag[9] =  0 ;  previous_node[9] = 27 ; 
distance_from_starting_node[10] = 100 ; status_flag[10] = 0 ;  previous_node[10] = 27 ; 
distance_from_starting_node[11] = 100 ; status_flag[11] = 0 ;  previous_node[11] = 27 ; 
distance_from_starting_node[12] = 100 ; status_flag[12] = 0 ;  previous_node[12] = 27 ; 
distance_from_starting_node[13] = 100 ; status_flag[13] = 0 ;  previous_node[13] = 27 ; 
distance_from_starting_node[14] = 100 ; status_flag[14] = 0 ;  previous_node[14] = 27 ; 
distance_from_starting_node[15] = 100 ; status_flag[15] = 0 ;  previous_node[15] = 27 ; 
distance_from_starting_node[16] = 100 ; status_flag[16] = 0 ;  previous_node[16] = 27 ; 
distance_from_starting_node[17] = 100 ; status_flag[17] = 0 ;  previous_node[17] = 27 ; 
distance_from_starting_node[18] = 100 ; status_flag[18] = 0 ;  previous_node[18] = 27 ; 
distance_from_starting_node[19] = 100 ; status_flag[19] = 0 ;  previous_node[19] = 27 ; 
distance_from_starting_node[20] = 100 ; status_flag[20] = 0 ;  previous_node[20] = 27 ; 
distance_from_starting_node[21] = 100 ; status_flag[21] = 0 ;  previous_node[21] = 27 ; 
distance_from_starting_node[22] = 100 ; status_flag[22] = 0 ;  previous_node[22] = 27 ; 
distance_from_starting_node[23] = 100 ; status_flag[23] = 0 ;  previous_node[23] = 27 ; 
distance_from_starting_node[24] = 100 ; status_flag[24] = 0 ;  previous_node[24] = 27 ; 
distance_from_starting_node[25] = 100 ; status_flag[25] = 0 ;  previous_node[25] = 27 ; 
distance_from_starting_node[26] = 100 ; status_flag[26] = 1 ;  previous_node[26] = 27 ;  // imaginary node 

done = 1'b1;
counter_working     = 0 ;
list_update_working = 0 ; 
print_working       = 0 ;
trace_path_working  = 0 ;
counter = 0 ;
final_path = 0 ;
activate_main_loop = 1 ;
print_working_initial  = 0 ;



end 

// --- xxx ---
 
								// ------------------- //
								//    Made by Team     //
								//       SB#1135       //
								// ------------------- //
 
// --- main loop --- 
always @(negedge clk )
begin

// ------- Section - 1 -------
	if(start == 1 && activate_main_loop == 1)                      
		begin		
			counter_working     = 1 ;     // As soon as 'start' become high main part of algo start working
			list_update_working = 1 ;	   // i.e searching for nearby nodes && to update them with shortest distance
			print_working = 1 ;

			least_value = 100 ;
			trace_path_working  = 0 ;
			counter = 0 ;
			activate_main_loop = 0 ;
			done_flag = 0 ;
		end 
// --- xxx ---

// ------- Section - 2 -------
	if (counter <= 25 && counter_working == 1)      // part of main code to search for shortest path  
		begin 
		distance_from_starting_node[e_node] = 0 ;
		if(distance_from_starting_node[counter] < least_value && status_flag[counter] == 0) 
			begin	
				hopper = counter ; 
				least_value = distance_from_starting_node[counter]  ;
			end 
		end 
// --- xxx ---

// ------- Section - 3 -------
	if (hopper == s_node)               // As soon as algo finds that shortest path is end node it stop searching  
		begin                            // and starts next phase of code that is to stop main loop and print shortest path  
			counter_working = 0 ;
			list_update_working = 0 ;
			trace_path_working = 1 ;
			print_working_initial  = 0 ;
			Final_Path = Final_Path << 5 ;
			Final_Path = Final_Path + s_node ;
			
//			$display ("previous path : %d" , s_node ) ;
		end 
// --- xxx ---

// ------- Section - 4 -------
	if (counter >= 26 && list_update_working == 1 ) // this part of code update nodes with shortest path to visit them  
		begin  

		if (counter == 26  && distance_from_starting_node[adjacent_nodes[hopper][0]] > path_of_adjacent_nodes[hopper][0] + distance_from_starting_node[hopper]) 
			begin 
				distance_from_starting_node[adjacent_nodes[hopper][0]] = path_of_adjacent_nodes[hopper][0] +  distance_from_starting_node[hopper];
				previous_node[adjacent_nodes[hopper][0]] = hopper ;
			end 
		
		else if (counter == 27  && distance_from_starting_node[adjacent_nodes[hopper][1]] > path_of_adjacent_nodes[hopper][1]+ distance_from_starting_node[hopper] ) 
			begin 
				distance_from_starting_node[adjacent_nodes[hopper][1]] = path_of_adjacent_nodes[hopper][1] + distance_from_starting_node[hopper];
				previous_node[adjacent_nodes[hopper][1]] = hopper ;
			end 
		
		else if (counter == 28  && distance_from_starting_node[adjacent_nodes[hopper][2]] > path_of_adjacent_nodes[hopper][2] + distance_from_starting_node[hopper]) 
			begin 
				distance_from_starting_node[adjacent_nodes[hopper][2]] = path_of_adjacent_nodes[hopper][2] + distance_from_starting_node[hopper];
				previous_node[adjacent_nodes[hopper][2]] = hopper ;
			end 
		
		else if (counter == 29  && distance_from_starting_node[adjacent_nodes[hopper][3]] > path_of_adjacent_nodes[hopper][3] + distance_from_starting_node[hopper]) 
			begin 
				distance_from_starting_node[adjacent_nodes[hopper][3]] = path_of_adjacent_nodes[hopper][3] + distance_from_starting_node[hopper];
				previous_node[adjacent_nodes[hopper][3]] = hopper ;	
			end 
	end 
// --- xxx ---

// ------- Section - 5 -------
	counter = counter + 1 ;
	main_counter = main_counter + 1 ;
//	$display ("counter %d , main counter %d " , counter , main_counter) ;
// --- xxx ---	


 // ------- Section - 6 -------
	if (counter == 30 && print_working == 1)
		begin 
			status_flag[hopper] = 1 ;
			counter = 0 ;
			least_value = 100 ;
			if(print_working_initial == 1)  begin print_working = 0; end 
		end
// --- xxx ---	

// ------- Section - 7 -------
	if (trace_path_working == 1)
		begin
			previous_path = previous_node[hopper] ;
			hopper = previous_path;
			if(hopper != 27) 
				begin  
					Final_Path = Final_Path << 5 ;
					Final_Path = Final_Path + previous_path ;
//					$display ("path is : %d",previous_path );
				end 
			else 
				begin 
					trace_path_working = 0 ; 
					final_path = Final_Path ;
					activate_update_loop = 1 ;
					done_flag = 1 ;
				end 
		end 
// --- xxx ---
	
// ------- Section - 8 -------
//	if (main_counter == 11'b11001110011)
	if ( activate_update_loop == 1 && start == 1 )
		begin 
			main_counter = 0 ;
			activate_main_loop = 1 ;
			hopper = 27 ;
			print_working_initial = 0 ;
			Final_Path = 50'b11011110111101111011110111101111011110111101111011 ;
			distance_from_starting_node[0]  = 100 ; status_flag[0] =  0 ;  previous_node[0] = 27 ; 
			distance_from_starting_node[1]  = 100 ; status_flag[1] =  0 ;  previous_node[1] = 27 ; 
			distance_from_starting_node[2]  = 100 ; status_flag[2] =  0 ;  previous_node[2] = 27; 
			distance_from_starting_node[3]  = 100 ; status_flag[3] =  0 ;  previous_node[3] = 27 ; 
			distance_from_starting_node[4]  = 100 ; status_flag[4] =  0 ;  previous_node[4] = 27 ; 
			distance_from_starting_node[5]  = 100 ; status_flag[5] =  0 ;  previous_node[5] = 27 ; 
			distance_from_starting_node[6]  = 100 ; status_flag[6] =  0 ;  previous_node[6] = 27 ; 
			distance_from_starting_node[7]  = 100 ; status_flag[7] =  0 ;  previous_node[7] = 27 ; 
			distance_from_starting_node[8]  = 100 ; status_flag[8] =  0 ;  previous_node[8] = 27 ; 
			distance_from_starting_node[9]  = 100 ; status_flag[9] =  0 ;  previous_node[9] = 27 ; 
			distance_from_starting_node[10] = 100 ; status_flag[10] = 0 ;  previous_node[10] = 27 ; 
			distance_from_starting_node[11] = 100 ; status_flag[11] = 0 ;  previous_node[11] = 27 ; 
			distance_from_starting_node[12] = 100 ; status_flag[12] = 0 ;  previous_node[12] = 27 ; 
			distance_from_starting_node[13] = 100 ; status_flag[13] = 0 ;  previous_node[13] = 27 ; 
			distance_from_starting_node[14] = 100 ; status_flag[14] = 0 ;  previous_node[14] = 27 ; 
			distance_from_starting_node[15] = 100 ; status_flag[15] = 0 ;  previous_node[15] = 27 ; 
			distance_from_starting_node[16] = 100 ; status_flag[16] = 0 ;  previous_node[16] = 27 ; 
			distance_from_starting_node[17] = 100 ; status_flag[17] = 0 ;  previous_node[17] = 27 ; 
			distance_from_starting_node[18] = 100 ; status_flag[18] = 0 ;  previous_node[18] = 27 ; 
			distance_from_starting_node[19] = 100 ; status_flag[19] = 0 ;  previous_node[19] = 27 ; 
			distance_from_starting_node[20] = 100 ; status_flag[20] = 0 ;  previous_node[20] = 27 ; 
			distance_from_starting_node[21] = 100 ; status_flag[21] = 0 ;  previous_node[21] = 27 ; 
			distance_from_starting_node[22] = 100 ; status_flag[22] = 0 ;  previous_node[22] = 27 ; 
			distance_from_starting_node[23] = 100 ; status_flag[23] = 0 ;  previous_node[23] = 27 ; 
			distance_from_starting_node[24] = 100 ; status_flag[24] = 0 ;  previous_node[24] = 27 ; 
			distance_from_starting_node[25] = 100 ; status_flag[25] = 0 ;  previous_node[25] = 27 ; 
			distance_from_starting_node[26] = 100 ; status_flag[26] = 1 ;  previous_node[26] = 27 ;  // imaginary node
			activate_update_loop = 0 ;
			done_flag = 0 ;
//			final_path = 0 ;
//			$display ("updated") ;
	end 
// --- xxx ---


end 

// ------- section - 9 -------
always @(posedge start or posedge done_flag )     // to control done flag 
begin
if (start == 1) done = 0 ;
if (done_flag == 1) done = 1 ;
end 
// --- xxx ---

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////