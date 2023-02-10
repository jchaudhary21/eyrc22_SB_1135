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
/////////////// ____ MAP STORE IN LIST _______  //////////////
	
localparam 
				north        = 3'b000 ,   //0
				east         = 3'b001 ,   //1
				south        = 3'b010 ,   //2
				west         = 3'b011 ,   //3
            northeast    = 3'b100 ,   //4
				southwest    = 3'b100 ,   //5
				no_direction = 3'b111 ,   //6
				
				straight     =  4'b1000 , // 8
				left         =  4'b1001 , // 9
			   right        =  4'b1010 , // 10
			   dgr_180_R    =  4'b1011 , // 11
				dgr_180_L    =  4'b1100 ;  //12

reg [10:0]  inf = 100 ;
				

reg [10:0] adjacent_nodes[25:0][3:0] ;
reg [10:0] path_of_adjacent_nodes[25:0][3:0] ;
reg [10:0] final_heading [25:0][3:0] ;
reg [10:0] turn_to_reach [25:0][3:0] ;	
reg [10:0] turns_map [6:0][6:0]  ;
	

reg flag_initalize_map  = 1 ;
	

always @ ( posedge clk )
begin

	if (flag_initalize_map == 1 )
	begin
	
	// node 0 : 
	
	adjacent_nodes         [0][0] = 1            ; adjacent_nodes         [0][1] = 26           ; adjacent_nodes         [0][2] = 26           ; adjacent_nodes         [0][3] = 26;
   path_of_adjacent_nodes [0][0] = 3            ; path_of_adjacent_nodes [0][1] = inf          ; path_of_adjacent_nodes [0][2] = inf          ; path_of_adjacent_nodes [0][3] = inf ;
	final_heading          [0][0] = east         ; final_heading          [0][1] = no_direction ; final_heading          [0][2] = no_direction ; final_heading          [0][3] = no_direction ; 
	turn_to_reach          [0][0] = south        ; turn_to_reach          [0][1] = no_direction ; turn_to_reach          [0][2] = no_direction ; turn_to_reach          [0][3] = no_direction ; 

   // node 1 : 
	
	adjacent_nodes         [1][0] = 0             ; adjacent_nodes         [1][1] = 2            ; adjacent_nodes         [1][2] = 13           ; adjacent_nodes         [1][3] = 26;
   path_of_adjacent_nodes [1][0] = 3             ; path_of_adjacent_nodes [1][1] = 3            ; path_of_adjacent_nodes [1][2] = 3            ; path_of_adjacent_nodes [1][3] = inf ;
	final_heading          [1][0] = north         ; final_heading          [1][1] = south        ; final_heading          [1][2] = east         ; final_heading          [1][3] = no_direction ; 
	turn_to_reach          [1][0] = west          ; turn_to_reach          [1][1] = south        ; turn_to_reach          [1][2] = east         ; turn_to_reach          [1][3] = no_direction ; 

	// node 2 : 
	
	adjacent_nodes         [2][0] = 1             ; adjacent_nodes         [2][1] = 3            ; adjacent_nodes         [2][2] = 5            ; adjacent_nodes         [2][3] = 26;
   path_of_adjacent_nodes [2][0] = 3             ; path_of_adjacent_nodes [2][1] = 1            ; path_of_adjacent_nodes [2][2] = 3            ; path_of_adjacent_nodes [2][3] = inf ;
	final_heading          [2][0] = north         ; final_heading          [2][1] = east         ; final_heading          [2][2] = south        ; final_heading          [2][3] = no_direction ; 
	turn_to_reach          [2][0] = north         ; turn_to_reach          [2][1] = east         ; turn_to_reach          [2][2] = south        ; turn_to_reach          [2][3] = no_direction ; 

	// node 3 : 
	
	adjacent_nodes         [3][0] = 2             ; adjacent_nodes         [3][1] = 26           ; adjacent_nodes         [3][2] = 26           ; adjacent_nodes         [3][3] = 26;
   path_of_adjacent_nodes [3][0] = 1             ; path_of_adjacent_nodes [3][1] = inf          ; path_of_adjacent_nodes [3][2] = inf          ; path_of_adjacent_nodes [3][3] = inf ;
	final_heading          [3][0] = west          ; final_heading          [3][1] = no_direction ; final_heading          [3][2] = no_direction ; final_heading          [3][3] = no_direction ; 
	turn_to_reach          [3][0] = west          ; turn_to_reach          [3][1] = no_direction ; turn_to_reach          [3][2] = no_direction ; turn_to_reach          [3][3] = no_direction ; 

	// node 4 : 
	
	adjacent_nodes         [4][0] = 6             ; adjacent_nodes         [4][1] = 26           ; adjacent_nodes         [4][2] = 26           ; adjacent_nodes         [4][3] = 26;
   path_of_adjacent_nodes [4][0] = 3             ; path_of_adjacent_nodes [4][1] = inf          ; path_of_adjacent_nodes [4][2] = inf          ; path_of_adjacent_nodes [4][3] = inf ;
	final_heading          [4][0] = northeast     ; final_heading          [4][1] = no_direction ; final_heading          [4][2] = no_direction ; final_heading          [4][3] = no_direction ; 
	turn_to_reach          [4][0] = south         ; turn_to_reach          [4][1] = no_direction ; turn_to_reach          [4][2] = no_direction ; turn_to_reach          [4][3] = no_direction ; 

	// node 5 : 
	
	adjacent_nodes         [5][0] = 2             ; adjacent_nodes         [5][1] =  6           ; adjacent_nodes         [5][2] = 9            ; adjacent_nodes         [5][3] = 26;
   path_of_adjacent_nodes [5][0] = 3             ; path_of_adjacent_nodes [5][1] =  1           ; path_of_adjacent_nodes [5][2] = 2            ; path_of_adjacent_nodes [5][3] = inf ;
	final_heading          [5][0] = north         ; final_heading          [5][1] = south        ; final_heading          [5][2] = east         ; final_heading          [5][3] = no_direction ; 
	turn_to_reach          [5][0] = north         ; turn_to_reach          [5][1] = south        ; turn_to_reach          [5][2] = east         ; turn_to_reach          [5][3] = no_direction ; 

	// node 6 : 
	
	adjacent_nodes         [6][0] = 4             ; adjacent_nodes         [6][1] = 5            ; adjacent_nodes         [6][2] =  16          ; adjacent_nodes         [6][3] = 26;
   path_of_adjacent_nodes [6][0] = 3             ; path_of_adjacent_nodes [6][1] = 1            ; path_of_adjacent_nodes [6][2] =  3           ; path_of_adjacent_nodes [6][3] = inf ;
	final_heading          [6][0] = north         ; final_heading          [6][1] = north        ; final_heading          [6][2] = east         ; final_heading          [6][3] = no_direction ; 
	turn_to_reach          [6][0] = southwest     ; turn_to_reach          [6][1] = north        ; turn_to_reach          [6][2] = east         ; turn_to_reach          [6][3] = no_direction ; 

	// node 7 : 
	
	adjacent_nodes         [7][0] = 12            ; adjacent_nodes         [7][1] = 26           ; adjacent_nodes         [7][2] = 26           ; adjacent_nodes         [7][3] = 26;
   path_of_adjacent_nodes [7][0] = 2             ; path_of_adjacent_nodes [7][1] = inf          ; path_of_adjacent_nodes [7][2] = inf          ; path_of_adjacent_nodes [7][3] = inf ;
	final_heading          [7][0] = east          ; final_heading          [7][1] = no_direction ; final_heading          [7][2] = no_direction ; final_heading          [7][3] = no_direction ; 
	turn_to_reach          [7][0] = south         ; turn_to_reach          [7][1] = no_direction ; turn_to_reach          [7][2] = no_direction ; turn_to_reach          [7][3] = no_direction ; 

	// node 8 : 
	
	adjacent_nodes         [8][0] = 9             ; adjacent_nodes         [8][1] = 26           ; adjacent_nodes         [8][2] = 26           ; adjacent_nodes         [8][3] = 26;
   path_of_adjacent_nodes [8][0] = 1             ; path_of_adjacent_nodes [8][1] = inf          ; path_of_adjacent_nodes [8][2] = inf          ; path_of_adjacent_nodes [8][3] = inf ;
	final_heading          [8][0] = south         ; final_heading          [8][1] = no_direction ; final_heading          [8][2] = no_direction ; final_heading          [8][3] = no_direction ; 
	turn_to_reach          [8][0] = south         ; turn_to_reach          [8][1] = no_direction ; turn_to_reach          [8][2] = no_direction ; turn_to_reach          [8][3] = no_direction ; 

	// node 9 : 
	
	adjacent_nodes         [9][0] = 8             ; adjacent_nodes         [9][1] = 5            ; adjacent_nodes         [9][2] = 15           ; adjacent_nodes         [9][3] = 26;
   path_of_adjacent_nodes [9][0] = 1             ; path_of_adjacent_nodes [9][1] = 2            ; path_of_adjacent_nodes [9][2] = 1            ; path_of_adjacent_nodes [9][3] = inf ;
	final_heading          [9][0] = north         ; final_heading          [9][1] = west         ; final_heading          [9][2] = east         ; final_heading          [9][3] = no_direction ; 
	turn_to_reach          [9][0] = north         ; turn_to_reach          [9][1] = west         ; turn_to_reach          [9][2] = east         ; turn_to_reach          [9][3] = no_direction ; 

	// node 10 : 
	
	adjacent_nodes         [10][0] = 16            ; adjacent_nodes         [10][1] = 26           ; adjacent_nodes         [10][2] = 26           ; adjacent_nodes         [10][3] = 26;
   path_of_adjacent_nodes [10][0] = 2             ; path_of_adjacent_nodes [10][1] = inf          ; path_of_adjacent_nodes [10][2] = inf          ; path_of_adjacent_nodes [10][3] = inf ;
	final_heading          [10][0] = south         ; final_heading          [10][1] = no_direction ; final_heading          [10][2] = no_direction ; final_heading          [10][3] = no_direction ; 
	turn_to_reach          [10][0] = east          ; turn_to_reach          [10][1] = no_direction ; turn_to_reach          [10][2] = no_direction ; turn_to_reach          [10][3] = no_direction ; 

	// node 11 : 
	
	adjacent_nodes         [11][0] = 12            ; adjacent_nodes         [11][1] = 26           ; adjacent_nodes         [11][2] = 26           ; adjacent_nodes         [11][3] = 26;
   path_of_adjacent_nodes [11][0] = 3             ; path_of_adjacent_nodes [11][1] = inf          ; path_of_adjacent_nodes [11][2] = inf          ; path_of_adjacent_nodes [11][3] = inf ;
	final_heading          [11][0] = south         ; final_heading          [11][1] = no_direction ; final_heading          [11][2] = no_direction ; final_heading          [11][3] = no_direction ; 
	turn_to_reach          [11][0] = west          ; turn_to_reach          [11][1] = no_direction ; turn_to_reach          [11][2] = no_direction ; turn_to_reach          [11][3] = no_direction ; 

	// node 12 : 
	
	adjacent_nodes         [12][0] = 7             ; adjacent_nodes         [12][1] = 11           ; adjacent_nodes         [12][2] = 17           ; adjacent_nodes         [12][3] = 13;
   path_of_adjacent_nodes [12][0] = 2             ; path_of_adjacent_nodes [12][1] = 3            ; path_of_adjacent_nodes [12][2] = 3            ; path_of_adjacent_nodes [12][3] = 1 ;
	final_heading          [12][0] = north         ; final_heading          [12][1] = east         ; final_heading          [12][2] = east         ; final_heading          [12][3] = south ; 
	turn_to_reach          [12][0] = west          ; turn_to_reach          [12][1] = north        ; turn_to_reach          [12][2] = east         ; turn_to_reach          [12][3] = south ; 

	// node 13 : 
	
	adjacent_nodes         [13][0] = 1             ; adjacent_nodes         [13][1] = 18           ; adjacent_nodes         [13][2] = 12           ; adjacent_nodes         [13][3] = 26;
   path_of_adjacent_nodes [13][0] = 3             ; path_of_adjacent_nodes [13][1] = 2            ; path_of_adjacent_nodes [13][2] = 1            ; path_of_adjacent_nodes [13][3] = inf ;
	final_heading          [13][0] = west          ; final_heading          [13][1] = east         ; final_heading          [13][2] = north        ; final_heading          [13][3] = no_direction ; 
	turn_to_reach          [13][0] = west          ; turn_to_reach          [13][1] = east         ; turn_to_reach          [13][2] = north        ; turn_to_reach          [13][3] = no_direction ; 

	// node 14 : 
	
	adjacent_nodes         [14][0] = 15            ; adjacent_nodes         [14][1] = 26           ; adjacent_nodes         [14][2] = 26           ; adjacent_nodes         [14][3] = 26;
   path_of_adjacent_nodes [14][0] = 1             ; path_of_adjacent_nodes [14][1] = inf          ; path_of_adjacent_nodes [14][2] = inf          ; path_of_adjacent_nodes [14][3] = inf ;
	final_heading          [14][0] = south         ; final_heading          [14][1] = no_direction ; final_heading          [14][2] = no_direction ; final_heading          [14][3] = no_direction ; 
	turn_to_reach          [14][0] = south         ; turn_to_reach          [14][1] = no_direction ; turn_to_reach          [14][2] = no_direction ; turn_to_reach          [14][3] = no_direction ; 

	// node 15 : 
	
	adjacent_nodes         [15][0] = 22            ; adjacent_nodes         [15][1] = 9            ; adjacent_nodes         [15][2] = 14           ; adjacent_nodes         [15][3] = 26;
   path_of_adjacent_nodes [15][0] = 1             ; path_of_adjacent_nodes [15][1] = 1            ; path_of_adjacent_nodes [15][2] = 1            ; path_of_adjacent_nodes [15][3] = inf ;
	final_heading          [15][0] = east          ; final_heading          [15][1] = west         ; final_heading          [15][2] = north        ; final_heading          [15][3] = no_direction ; 
	turn_to_reach          [15][0] = east          ; turn_to_reach          [15][1] = west         ; turn_to_reach          [15][2] = north        ; turn_to_reach          [15][3] = no_direction ; 

	// node 16 : 
	
	adjacent_nodes         [16][0] = 10            ; adjacent_nodes         [16][1] = 23           ; adjacent_nodes         [16][2] =  6           ; adjacent_nodes         [16][3] = 26;
   path_of_adjacent_nodes [16][0] = 2             ; path_of_adjacent_nodes [16][1] = 2            ; path_of_adjacent_nodes [16][2] = 3            ; path_of_adjacent_nodes [16][3] = inf ;
	final_heading          [16][0] = west          ; final_heading          [16][1] = north        ; final_heading          [16][2] = north        ; final_heading          [16][3] = no_direction ; 
	turn_to_reach          [16][0] = north         ; turn_to_reach          [16][1] = east         ; turn_to_reach          [16][2] = west         ; turn_to_reach          [16][3] = no_direction ; 

	// node 17 : 
	
	adjacent_nodes         [17][0] = 12            ; adjacent_nodes         [17][1] = 26           ; adjacent_nodes         [17][2] = 26           ; adjacent_nodes         [17][3] = 26;
   path_of_adjacent_nodes [17][0] = 3             ; path_of_adjacent_nodes [17][1] = inf          ; path_of_adjacent_nodes [17][2] = inf          ; path_of_adjacent_nodes [17][3] = inf ;
	final_heading          [17][0] = west          ; final_heading          [17][1] = no_direction ; final_heading          [17][2] = no_direction ; final_heading          [17][3] = no_direction ; 
	turn_to_reach          [17][0] = west          ; turn_to_reach          [17][1] = no_direction ; turn_to_reach          [17][2] = no_direction ; turn_to_reach          [17][3] = no_direction ; 

	// node 18 : 
	
	adjacent_nodes         [18][0] = 19            ; adjacent_nodes         [18][1] = 13           ; adjacent_nodes         [18][2] = 20           ; adjacent_nodes         [18][3] = 26;
   path_of_adjacent_nodes [18][0] = 1             ; path_of_adjacent_nodes [18][1] = 2            ; path_of_adjacent_nodes [18][2] = 1            ; path_of_adjacent_nodes [18][3] = inf ;
	final_heading          [18][0] = east          ; final_heading          [18][1] = west         ; final_heading          [18][2] = south		  ; final_heading          [18][3] = no_direction ; 
	turn_to_reach          [18][0] = east          ; turn_to_reach          [18][1] = west         ; turn_to_reach          [18][2] = south        ; turn_to_reach          [18][3] = no_direction ; 

	// node 19 : 
	
	adjacent_nodes         [19][0] = 18            ; adjacent_nodes         [19][1] = 26           ; adjacent_nodes         [19][2] = 26           ; adjacent_nodes         [19][3] = 26;
   path_of_adjacent_nodes [19][0] = 1             ; path_of_adjacent_nodes [19][1] = inf          ; path_of_adjacent_nodes [19][2] = inf          ; path_of_adjacent_nodes [19][3] = inf ;
	final_heading          [19][0] = west          ; final_heading          [19][1] = no_direction ; final_heading          [19][2] = no_direction ; final_heading          [19][3] = no_direction ; 
	turn_to_reach          [19][0] = west          ; turn_to_reach          [19][1] = no_direction ; turn_to_reach          [19][2] = no_direction ; turn_to_reach          [19][3] = no_direction ; 

	// node 20 : 
	
	adjacent_nodes         [20][0] = 21            ; adjacent_nodes         [20][1] = 18           ; adjacent_nodes         [20][2] = 22           ; adjacent_nodes         [20][3] = 26;
   path_of_adjacent_nodes [20][0] = 1             ; path_of_adjacent_nodes [20][1] = 1            ; path_of_adjacent_nodes [20][2] = 2            ; path_of_adjacent_nodes [20][3] = inf ;
	final_heading          [20][0] = east          ; final_heading          [20][1] = north        ; final_heading          [20][2] = south        ; final_heading          [20][3] = no_direction ; 
	turn_to_reach          [20][0] = east          ; turn_to_reach          [20][1] = north        ; turn_to_reach          [20][2] = south        ; turn_to_reach          [20][3] = no_direction ; 


	// node 21 : 
	
	adjacent_nodes         [21][0] = 20            ; adjacent_nodes         [21][1] = 26           ; adjacent_nodes         [21][2] = 26           ; adjacent_nodes         [21][3] = 26;
   path_of_adjacent_nodes [21][0] = 1             ; path_of_adjacent_nodes [21][1] = inf          ; path_of_adjacent_nodes [21][2] = inf          ; path_of_adjacent_nodes [21][3] = inf ;
	final_heading          [21][0] = west          ; final_heading          [21][1] = no_direction ; final_heading          [21][2] = no_direction ; final_heading          [21][3] = no_direction ; 
	turn_to_reach          [21][0] = west          ; turn_to_reach          [21][1] = no_direction ; turn_to_reach          [21][2] = no_direction ; turn_to_reach          [21][3] = no_direction ; 

	// node 22 : 
	
	adjacent_nodes         [22][0] = 15            ; adjacent_nodes         [22][1] = 20           ; adjacent_nodes         [22][2] = 25           ; adjacent_nodes         [22][3] = 23;
   path_of_adjacent_nodes [22][0] = 1             ; path_of_adjacent_nodes [22][1] = 2            ; path_of_adjacent_nodes [22][2] = 3            ; path_of_adjacent_nodes [22][3] = 1 ;
	final_heading          [22][0] = west          ; final_heading          [22][1] = north        ; final_heading          [22][2] = south        ; final_heading          [22][3] = south ; 
	turn_to_reach          [22][0] = west          ; turn_to_reach          [22][1] = north        ; turn_to_reach          [22][2] = east         ; turn_to_reach          [22][3] = south ; 

	// node 23 : 
	
	adjacent_nodes         [23][0] = 24            ; adjacent_nodes         [23][1] = 22           ; adjacent_nodes         [23][2] = 16           ; adjacent_nodes         [23][3] = 26;
   path_of_adjacent_nodes [23][0] = 2             ; path_of_adjacent_nodes [23][1] = 1            ; path_of_adjacent_nodes [23][2] = 2            ; path_of_adjacent_nodes [23][3] = inf ;
	final_heading          [23][0] = south         ; final_heading          [23][1] = north        ; final_heading          [23][2] = west         ; final_heading          [23][3] = no_direction ; 
	turn_to_reach          [23][0] = west          ; turn_to_reach          [23][1] = north        ; turn_to_reach          [23][2] = south        ; turn_to_reach          [23][3] = no_direction ; 

	// node 24 : 
	
	adjacent_nodes         [24][0] = 23            ; adjacent_nodes         [24][1] = 26           ; adjacent_nodes         [24][2] = 26           ; adjacent_nodes         [24][3] = 26;
   path_of_adjacent_nodes [24][0] = 2             ; path_of_adjacent_nodes [24][1] = inf          ; path_of_adjacent_nodes [24][2] = inf          ; path_of_adjacent_nodes [24][3] = inf ;
	final_heading          [24][0] = west          ; final_heading          [24][1] = no_direction ; final_heading          [24][2] = no_direction ; final_heading          [24][3] = no_direction ; 
	turn_to_reach          [24][0] = north         ; turn_to_reach          [24][1] = no_direction ; turn_to_reach          [24][2] = no_direction ; turn_to_reach          [24][3] = no_direction ; 

	// node 25 : 
	
	adjacent_nodes         [25][0] = 22            ; adjacent_nodes         [25][1] = 26           ; adjacent_nodes         [25][2] = 26           ; adjacent_nodes         [25][3] = 26;
   path_of_adjacent_nodes [25][0] = 3             ; path_of_adjacent_nodes [25][1] = inf          ; path_of_adjacent_nodes [25][2] = inf          ; path_of_adjacent_nodes [25][3] = inf ;
	final_heading          [25][0] = west          ; final_heading          [25][1] = no_direction ; final_heading          [25][2] = no_direction ; final_heading          [25][3] = no_direction ; 
	turn_to_reach          [25][0] = north         ; turn_to_reach          [25][1] = no_direction ; turn_to_reach          [25][2] = no_direction ; turn_to_reach          [25][3] = no_direction ; 
   
	
	
	// north
	
	turns_map [north][north]         = straight  ; turns_map [north][east]          = right     ; turns_map [north][west]     = left      ; turns_map [north][south]     = dgr_180_R ;
	turns_map [north][northeast]     = right     ; turns_map [north][southwest]     = dgr_180_L ;
	
	
	// north
	
	turns_map [east][north]          = left      ; turns_map [east][east]           = straight  ; turns_map [east][west]      = dgr_180_R ; turns_map [east][south]      = right     ; 
	turns_map [east][northeast]      = left      ; turns_map [east][southwest]      = dgr_180_R ;
	
	
	// west
	
	turns_map [west][north]          = right     ; turns_map [west][east]           = dgr_180_R ; turns_map [west][west]      = straight  ; turns_map [west][south]      = left      ; 
   turns_map [west][northeast]      = dgr_180_R ; turns_map [west][southwest]      = left      ;   

	// south
	
	turns_map [south][north]         = dgr_180_R ; turns_map [south][east]          = left      ; turns_map [south][west]     = right     ; turns_map [south][south]     = straight  ;
   turns_map [south][northeast]     = dgr_180_L ; turns_map [south][southwest]     = right     ;
	
	// northeast
	
	turns_map [northeast][north]     = left      ; turns_map [northeast][east]      = right     ; turns_map [northeast][west] = dgr_180_L ; turns_map [northeast][south] = dgr_180_R ; 
   turns_map [northeast][northeast] = straight  ; turns_map [northeast][southwest] = dgr_180_R ;
	
	// southwest
	
	turns_map [southwest][north]     = dgr_180_R ; turns_map [southwest][east]      = dgr_180_L ; turns_map [southwest][west] = right     ; turns_map [southwest][south] = left      ;
   turns_map [southwest][northeast] = dgr_180_R ; turns_map [southwest][southwest] = straight  ;

	
   flag_initalize_map = 0 ;

	end
end


//////////// ______ OPEN AND CLOSE LIST TO STORE DATA _______ ////////


reg [10:0] distance_from_starting_node[26:0] ;
reg [1:0]  status_flag[26:0] ;	
reg [10:0] previous_node[26:0] ;
reg [10:0] dirn_turns_list[26:0] ; 
reg [10:0] currt_heading[26:0] ;

reg flag_reset_list = 1 ;
reg flag_main_loop  = 1 ; 

always @ ( posedge clk )
begin

	if (flag_reset_list == 1 )
	begin
	
   //node 0 : 
 	distance_from_starting_node [0]  = inf ; status_flag [0]  = 0 ;  previous_node [0]  = 27 ;   dirn_turns_list[0] = 0 ;   currt_heading[0] = 0 ;  

	//node 1 :	
   distance_from_starting_node [1]  = inf ; status_flag [1]  = 0 ;  previous_node [1]  = 27 ;   dirn_turns_list[1] = 0 ;   currt_heading[1] = 0 ;
	
	//node 2 :
	distance_from_starting_node [2]  = inf ; status_flag [2]  = 0 ;  previous_node [2]  = 27 ;   dirn_turns_list[2] = 0 ;   currt_heading[2] = 0 ;
	
	//node 3 :
	distance_from_starting_node [3]  = inf ; status_flag [3]  = 0 ;  previous_node [3]  = 27 ;   dirn_turns_list[3] = 0 ;   currt_heading[3] = 0 ;
	
	//node 4 :
	distance_from_starting_node [4]  = inf ; status_flag [4]  = 0 ;  previous_node [4]  = 27 ;   dirn_turns_list[4] = 0 ;   currt_heading[4] = 0 ;
	
	//node 5 :
	distance_from_starting_node [5]  = inf ; status_flag [5]  = 0 ;  previous_node [5]  = 27 ;   dirn_turns_list[5] = 0 ;   currt_heading[5] = 0 ;
	
	//node 6 :
	distance_from_starting_node [6]  = inf ; status_flag [6]  = 0 ;  previous_node [6]  = 27 ;   dirn_turns_list[6] = 0 ;   currt_heading[6] = 0 ;
	
	//node 7 :
	distance_from_starting_node [7]  = inf ; status_flag [7]  = 0 ;  previous_node [7]  = 27 ;   dirn_turns_list[7] = 0 ;   currt_heading[7] = 0 ;
	
	//node 8 :
	distance_from_starting_node [8]  = inf ; status_flag [8]  = 0 ;  previous_node [8]  = 27 ;   dirn_turns_list[8] = 0 ;   currt_heading[8] = 0 ;
	
	//node 9 :
	distance_from_starting_node [9]  = inf ; status_flag [9]  = 0 ;  previous_node [9]  = 27 ;   dirn_turns_list[9] = 0 ;   currt_heading[9] = 0 ; 
	
	//node 10 :
	distance_from_starting_node [10] = inf ; status_flag [10] = 0 ;  previous_node [10] = 27 ;   dirn_turns_list[10] = 0 ;  currt_heading[10] = 0 ; 
	
	//node 11 :
	distance_from_starting_node [11] = inf ; status_flag [11] = 0 ;  previous_node [11] = 27 ;   dirn_turns_list[11] = 0 ;  currt_heading[11] = 0 ; 
	
	//node 12 :
	distance_from_starting_node [12] = inf ; status_flag [12] = 0 ;  previous_node [12] = 27 ;   dirn_turns_list[12] = 0 ;  currt_heading[12] = 0 ;
	
	//node 13 :
	distance_from_starting_node [13] = inf ; status_flag [13] = 0 ;  previous_node [13] = 27 ;   dirn_turns_list[13] = 0 ;  currt_heading[13] = 0 ;
	
	//node 14 :
	distance_from_starting_node [14] = inf ; status_flag [14] = 0 ;  previous_node [14] = 27 ;   dirn_turns_list[14] = 0 ;  currt_heading[14] = 0 ;
	
	//node 15 :
	distance_from_starting_node [15] = inf ; status_flag [15] = 0 ;  previous_node [15] = 27 ;   dirn_turns_list[15] = 0 ;  currt_heading[15] = 0 ;
	
	//node 16 :
	distance_from_starting_node [16] = inf ; status_flag [16] = 0 ;  previous_node [16] = 27 ;   dirn_turns_list[16] = 0 ;  currt_heading[16] = 0 ;
	
	//node 17 :
	distance_from_starting_node [17] = inf ; status_flag [17] = 0 ;  previous_node [17] = 27 ;   dirn_turns_list[17] = 0 ;  currt_heading[17] = 0 ;
	
	//node 18 :
	distance_from_starting_node [18] = inf ; status_flag [18] = 0 ;  previous_node [18] = 27 ;   dirn_turns_list[18] = 0 ;  currt_heading[18] = 0 ;
	
	//node 19 :
	distance_from_starting_node [19] = inf ; status_flag [19] = 0 ;  previous_node [19] = 27 ;   dirn_turns_list[19] = 0 ;  currt_heading[19] = 0 ;
	
	//node 20 :
	distance_from_starting_node [20] = inf ; status_flag [20] = 0 ;  previous_node [20] = 27 ;   dirn_turns_list[20] = 0 ;  currt_heading[20] = 0 ;
	
	//node 21 :
	distance_from_starting_node [21] = inf ; status_flag [21] = 0 ;  previous_node [21] = 27 ;   dirn_turns_list[21] = 0 ;  currt_heading[21] = 0 ;
	
	//node 22 :
	distance_from_starting_node [22] = inf ; status_flag [22] = 0 ;  previous_node [22] = 27 ;   dirn_turns_list[22] = 0 ;  currt_heading[22] = 0 ;
	
	//node 23 :
	distance_from_starting_node [23] = inf ; status_flag [23] = 0 ;  previous_node [23] = 27 ;   dirn_turns_list[23] = 0 ;  currt_heading[23] = 0 ;
	
	//node 24 :
	distance_from_starting_node [24] = inf ; status_flag [24] = 0 ;  previous_node [24] = 27 ;   dirn_turns_list[24] = 0 ;  currt_heading[24] = 0 ;
	
	//node 25 :
	distance_from_starting_node [25] = inf ; status_flag [25] = 0 ;  previous_node [25] = 27 ;   dirn_turns_list[25] = 0 ;  currt_heading[25] = 0 ;
	
	//node 26 :
	distance_from_starting_node [26] = inf ; status_flag [26] = 1 ;  previous_node [26] = 27 ;   dirn_turns_list[26] = 0 ;  currt_heading[26] = 0 ;

	flag_reset_list = 0 ;
	flag_main_loop  = 1 ;
	
	end
end


//////////// ______ PATH PLANNING MAIN LOOP  _______ ////////

reg flag_sub_node = 1 ;
reg flag_update_startDistance = 1 ;
reg flag_trace_node = 0 ;
reg flag_dirn_turns = 0 ;

reg [10:0] pth_pln_cnt = 1 ;
reg [10:0] cumt_dis = 0 ;
reg [10:0] least_value = 100  ; 

///////////////////////////////////// |I|
                                   // |M| 
reg [10:0] strt_node    = 21 ;     // |P|  ---\ keep value of both
reg [10:0] current_node = 21 ;     // |o|  ---/ variable same 
                                   // |R| 
reg [4:0]  heading_ptr  = north ;  // |T|  ----> orientation of bot in physical world
reg [10:0] end_node     = 4 ;      // |A|  ----> final destination of bot 
                                   // |N| 
///////////////////////////////////// |T| 

reg [49:0]node_string = 50'b11111111111111111111111111111111111111111111111111 ;   
 
always @ ( posedge clk )
begin
if (flag_main_loop == 1 )
begin



/// UPDATING START NODE INITAL DISTANCE ( ONE TIME )
 if ( flag_update_startDistance == 1 )
 begin
	distance_from_starting_node[strt_node] = 0 ; 
	currt_heading[strt_node] = heading_ptr ; 
	node_string = 50'b11111111111111111111111111111111111111111111111111 ;
	flag_update_startDistance = 0 ;
 end


 
/// UPDATING "CURRENT" NODE AND CHANGING VALUES OF PARAMETER      
 if ( pth_pln_cnt == 2 && flag_sub_node == 1  )
 begin
	status_flag[current_node] = 1 ; 
	least_value = 100 ;
//   $display("%d - %d",current_node,previous_node[current_node]) ;
 end



/// UPDATE SUB-NODE VALUES ///
 if (pth_pln_cnt > 2  && pth_pln_cnt <= 6 && flag_sub_node == 1 )
 begin
	if ( distance_from_starting_node[adjacent_nodes[current_node][pth_pln_cnt-3]]  > distance_from_starting_node[current_node] + path_of_adjacent_nodes[current_node][pth_pln_cnt-3] ) 
	begin
		distance_from_starting_node[adjacent_nodes[current_node][pth_pln_cnt-3]] = distance_from_starting_node[current_node] + path_of_adjacent_nodes[current_node][pth_pln_cnt-3] ;
		previous_node[adjacent_nodes[current_node][pth_pln_cnt-3]] = current_node ;
		
		currt_heading[adjacent_nodes[current_node][pth_pln_cnt-3]]   = final_heading[current_node][pth_pln_cnt-3] ;
		dirn_turns_list[adjacent_nodes[current_node][pth_pln_cnt-3]] = turns_map [currt_heading[current_node]][turn_to_reach[current_node][pth_pln_cnt - 3]] ;
		
		                                   
		/////////////////                                --   UNCOMMENT TO DEBUGG --                           ///////////////////////////////////////////
		//                                                                                                                                              //
		// $display ("current note - %d , nearby node - %d ", current_node , adjacent_nodes[current_node][pth_pln_cnt-3]) ;                             //
		// $display ("current heading of current node - %d ", currt_heading[current_node] ) ;                                                           //
		// $display ("heading after reaching node - %d " ,   final_heading[current_node][pth_pln_cnt - 3]) ;                                            //
		// $display ("action take to reach this node - %d ", turns_map [currt_heading[current_node]][turn_to_reach[current_node][pth_pln_cnt - 3]]  ) ; //
		// $display ("------------------------------------", ) ;                                                                                        //
		//                                                                                                                                              //
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	end 
 end
	
		
/// NEXT " CURRENT " NODE SELECTION FROM LIST 
 if ( pth_pln_cnt > 6 && pth_pln_cnt <= 32 && flag_sub_node == 1 )
 begin 
	if ( distance_from_starting_node[pth_pln_cnt - 7] < least_value && status_flag[pth_pln_cnt - 7] == 0 )
	begin
		least_value = distance_from_starting_node[pth_pln_cnt - 7] ;
		current_node = pth_pln_cnt - 7 ; 
 
	end 
 end
 

 
/// INTERUPT WHEN END NODE == CURRENT NODE 
 if (end_node == current_node && flag_sub_node == 1 )
 begin
	flag_sub_node = 0 ; 
	pth_pln_cnt = 0 ;
	flag_trace_node = 1 ;
 end  
 
 
 
/// TRACE BACK ALL NODES TO FIND PATH 
 if (flag_trace_node == 1 )
 begin
   node_string = node_string << 5 ;
	node_string = node_string + current_node ;
      
		$display (current_node ) ;
      if      (dirn_turns_list[current_node]  == 8)  $display ("straight") ;
		else if (dirn_turns_list[current_node]  == 9)  $display ("left") ;
		else if (dirn_turns_list[current_node]  == 10)  $display ("right") ;
		else if (dirn_turns_list[current_node]  == 11)  $display ("dgr_180_R") ;
		else if (dirn_turns_list[current_node]  == 12) $display ("dgr_180_L") ;
		
	current_node = previous_node[current_node] ;
   if ( current_node == 27 ) begin flag_trace_node = 0 ;	flag_dirn_turns = 1 ; end
 end


 
/// TURNS AND DIRECTION TAKEN BY BOT TO TRACE PATH  
// if ( flag_dirn_turns == 1 )
// begin
 
		/////////////////                                --   UNCOMMENT TO DEBUGG --                           //////////////////////
		//                                                                                                                         //
   	// $display ("%d",node_string[4:0]) ;                                                                                      //
		// if      (heading_ptr == 0 ) $display ("Current heading -  north") ;                                                     //
		// else if (heading_ptr == 1 ) $display ("Current heading - east") ;                                                       //
		// else if (heading_ptr == 2 ) $display ("Current heading - south") ;                                                      //
		// else if (heading_ptr == 3 ) $display ("Current heading - west") ;                                                       //
		// else if (heading_ptr == 4 ) $display ("Current heading - northeast") ;                                                  //
		// else if (heading_ptr == 5 ) $display ("Current heading - southwest") ;                                                  //
      //                                                                                                                         //
      // if      (turns_map[heading_ptr][turn_to_reach[heading_ptr][node_string[4:0]]] == 8)  $display ("straight") ;            //
	   //	else if (turns_map[heading_ptr][turn_to_reach[heading_ptr][node_string[4:0]]] == 9)  $display ("left") ;                //
	   //	else if (turns_map[heading_ptr][turn_to_reach[heading_ptr][node_string[4:0]]] == 10)  $display ("right") ;              //
	   //	else if (turns_map[heading_ptr][turn_to_reach[heading_ptr][node_string[4:0]]] == 11)  $display ("dgr_180_R") ;          //
	   //	else if (turns_map[heading_ptr][turn_to_reach[heading_ptr][node_string[4:0]]] == 12) $display ("dgr_180_L") ;           //
		//                                                                                                                         //
 		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
//      node_string  = node_string >> 5 ; 
//		heading_ptr = final_heading[heading_ptr][node_string[4:0]] ;
//
//		if (node_string[4:0] == 31 ) begin flag_dirn_turns = 0 ; end 
// end

/// reset pth_pln_cnt after 34 clock 
 if ( pth_pln_cnt == 34 )
 begin
	pth_pln_cnt = 0 ;
 end

 
pth_pln_cnt = pth_pln_cnt + 1 ;	
end
end
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////
