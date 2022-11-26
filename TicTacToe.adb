--Ada program for 2 player (player vs. player) tic-tac-toe.
with Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada;
procedure enums is
  --Using modulous to avoid being out of bounds of the board.
	type Index_Nums is mod 3;
  --col and row are limited to 1,2,& 3.
	col, row : Index_Nums;
  --Board will be a 2D array of chars (will be replaced by Symbols).
  type game is array(Index_Nums, Index_Nums) of Character;    
	Board : game := (('_','_','_'), ('_','_','_'), ('_','_','_'));
  --Chars to fill in empty spaces upon selection.
	Symbols : array(0..1) of Character := ('X','O');
  --Procedure to print the board with label numbers.
	procedure Display_Board(Board : game) is	
    --Number to label the spaces for selection. 
		label : Integer := 1;                       
	begin
    --loop to print board with space numbers line by line.
		for col in Index_Nums loop
			Ada.Text_IO.Put_Line(Integer'Image(label) & " |" 
      & Integer'Image(label+1)  & " |" & Integer'Image(label+2));
                                         
			Ada.Text_IO.Put_Line(" " & Board(col,0) & " | " 
      & Board(col,1) & " | " & Board(col,2));
			--Deliminter for second and third row.
			if col < 2 then
				Ada.Text_IO.Put_Line("---+---+---");   
				label := label + 3;
			end if;
		end loop;
	end Display_Board;

  --Converts selected space number to its column index number in 2D array.
  function Col_Of(Space_Num : Integer) return Index_Nums is   
	begin
		case Space_Num is                         
			when 1..3 => 
        return 0;   
			when 4..6 => 
        return 1;   
			when 7..9 => 
        return 2;
      --Need others for outside cases, should never enter this case.
			when others => 
        return 0; 
		end case;
	end Col_Of;

  --Converts slected space number to its row index number in 2D array.
  function Row_Of(Space_Num : Integer) return Index_Nums is
	begin
		case Space_Num is
			when 1|4|7 => 
        return 0;
			when 2|5|8 => 
        return 1;
			when 3|6|9 => 
        return 2;
      --Need others for outside cases, should never enter this case.
			when others => 
        return 0;
		end case;
	end Row_Of;	

  --Variable to store user input of selected space number.
  Space : Integer;
  --Counts total number of turns. Game is decided on or before turn 9.
  Turn_Count : Integer := 0;
  --Sentinel value to flag the end of game and exit Main loop.
  Sentinel : Integer := 0;
  --Variable to keep track of current player Symbol by passing in as --position of the Symbols array.
  Player_Num : Integer := 1;
  
begin
  --Players are told which is Symbol is theirs
  Ada.Text_IO.Put_Line("Player 1 is X and PLayer 2 is O.");    
  --Sentinel is set to 1 when a win condition is triggered.
	Main : loop
		exit when Sentinel /= 0;
    --Prints which player's turn it is currently.                       
		Ada.Text_IO.Put_Line("Player " & Integer'Image(Player_Num) 
    & "'s turn:");
		Display_Board(Board);
    --Current player selects a space.             
		Ada.Text_IO.Put_Line("Select a space number.");
		Ada.Integer_Text_IO.Get(Space);
    --Invalid space selection loop.
		while Space > 9 loop 
			Ada.Text_IO.Put_Line("Select an open space.");
			Ada.Integer_Text_IO.Get(Space);
		end loop;
    --The row and column of the selected space is stored.
    row := Row_Of(Space);
		col := Col_Of(Space);
    --Loop is entered when a filled space is selected.
		while Board(col, row) /= '_' loop
			Ada.Text_IO.Put_Line("Space is taken.");
			Ada.Integer_Text_IO.Get(Space);
      --Check again for out of bounds selection.
			while Space > 9 loop
				Ada.Text_IO.Put_Line("Select a space number.");
				Ada.Integer_Text_IO.Get(Space);
			end loop;
      --The open row and column of the selected space is stored.
			row := Row_Of(Space);
			col := Col_Of(Space);
		end loop;
    --The space is filled with the player's Symbol.
    --Player 1 is X, so (1-1 = 0) => Symbols(0) = 'X'.
		Board(col, row) := Symbols(Player_Num - 1);
		--Win condition for horizontal line.
		if Board(col, row) = Board(col, row+1) 
    and Board(col, row) = Board(col, row+2) then
      Display_Board(Board);
			Ada.Text_IO.Put_Line("Player" & Integer'Image(Player_Num) & " wins!");
			Sentinel := 1;
    --Win condition for vertical line.
		elsif Board(col, row) = Board(col+1, row) 
    and Board(col, row) = Board(col+2,row) then
			Display_Board(Board);
			Ada.Text_IO.Put_Line("Player" & Integer'Image(Player_Num) & " wins!");
			Sentinel:=1;
    --Win condition for TopLeft-to-right diagonal line.
		elsif col = row and Board(col, row) = Board(col+1,row+1) 
    and Board(col,row) = Board(col+2,row+2) then
			Display_Board(Board);
			Ada.Text_IO.Put_Line("Player" & Integer'Image(Player_Num) & " wins!");
			Sentinel:=1;
    --Win condition for TopRight-to-left diagonal line.
		elsif col+row = 2 and Board(col,row) = Board(col+1,row+2) 
    and Board(col,row) = Board(col+2,row+1) then
			Display_Board(Board);
			Ada.Text_IO.Put_Line("Player" & Integer'Image(Player_Num) & " wins!");
			Sentinel:=1;
    --Will always enter this case unless a win condition is met or 9 turns.
		else
			Player_Num := 3 - Player_Num;
			Turn_Count := Turn_Count + 1;
      --If no win after 9 turns then it must be a tie game.
			if Turn_Count = 9 then 
				Ada.Text_IO.Put_Line("Tie game!");
				Sentinel := 2;
			end if;
		end if;			
	end loop Main;

end enums;
