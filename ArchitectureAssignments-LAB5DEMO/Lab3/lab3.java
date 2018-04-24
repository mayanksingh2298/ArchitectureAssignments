import java.util.*;

public class lab3{
	public static int Tr = 8;
	public static int Tc = 8;

	public static char[][] game = new char[Tr][Tc];
	public static int check(char player){
		for(int i = 0;i<Tr;i++){
			for(int j = 0;j<Tc;j++){
				if(game[i][j] == ' '){
					if(update(i+1,j+1,player,false) > 0){
						return 0;
					}
				}
			}
		}
		return 1;
	}
	public static int update(int row,int col,char player,boolean chng){
		int changed = 0;
		row = row-1;
		col = col-1;
		for(int i = row-1;i>=0;i--){
			if((game[i][col] == ' ') || (game[i][col] == player)){
				if(game[i][col] == player){
					for(int x = i+1;x<row;x++){
						changed++;
						if(chng){
							game[x][col] = player;
						}
					}
				}
				break;
			}
		}
		for(int i = row+1;i<Tr;i++){
			if((game[i][col] == ' ') || (game[i][col] == player)){
				if(game[i][col] == player){
					for(int x = i-1;x>row;x--){
						changed++;
						if(chng){
							game[x][col] = player;
						}
					}
				}
				break;
			}	
		}
		for(int i = col+1;i<Tc;i++){
			if((game[row][i] == ' ') || (game[row][i] == player)){
				if(game[row][i] == player){
					for(int x = i-1;x>col;x--){
						changed++;
						if(chng){
							game[row][x] = player;
						}
					}
				}
				break;
			}
		}
		for(int i = col-1;i>=0;i--){
			if((game[row][i] == ' ') || (game[row][i] == player)){
				if(game[row][i] == player){
					for(int x = i+1;x<col;x++){
						changed++;
						if(chng){
							game[row][x] = player;
						}
					}
				}
				break;
			}	
		}
		int i = row+1,j = col+1;
		while(true){
			if((i < 0) || (j < 0) || (j >= Tc) || (i >= Tr)){
				break;
			}else{
				if((game[i][j] == ' ') || (game[i][j] == player)){
					if(game[i][j] == player){
						int x = i-1;int y = j-1;
						while((x>row)&&(y>col)){
							changed++;
							if(chng){
								game[x][y] = player;
							}
							x--;y--;
						}
					}
					break;
				}
				i++;j++;
			}
		}
		i = row-1;j = col-1;
		while(true){
			if((i < 0) || (j < 0) || (j >= Tc) || (i >= Tr)){
				break;		
			}else{
				if((game[i][j] == ' ') || (game[i][j] == player)){
					if(game[i][j] == player){
						int x = i+1;int y = j+1;
						while((x<row)&&(y<col)){
							changed++;
							if(chng){
								game[x][y] = player;
							}
							x++;y++;
						}
					}
					break;
				}
				i--;j--;
			}
		}
		i = row+1;j = col-1;
		while(true){
			if((i < 0) || (j < 0) || (j >= Tc) || (i >= Tr)){
				break;
			}else{
				if((game[i][j] == ' ') || (game[i][j] == player)){
					if(game[i][j] == player){
						int x = i-1;int y = j+1;
						while((x>row)&&(y<col)){
							changed++;
							if(chng){
								game[x][y] = player;
							}
							x--;y++;
						}
					}				
					break;
				}
				i++;j--;
			}
		}
		i = row-1;j = col+1;
		while(true){
			if((i < 0) || (j < 0) || (j >= Tc) || (i >= Tr)){
				break;
			}else{
				if((game[i][j] == ' ') || (game[i][j] == player)){
					if(game[i][j] == player){
						int x = i+1;int y = j-1;
						while((x<row)&&(y>col)){
							changed++;
							if(chng){
								game[x][y] = player;
							}
							x++;y--;
						}
					}
					break;
				}
				i--;j++;
			}
		}
		return changed;		
	}
	public static void main(String args[]){
		Scanner sc = new Scanner(System.in);
		for(int i = 0;i<Tr;i++){
			for(int j = 0;j<Tc;j++){
				game[i][j] = ' ';
			}
		}
		game[(Tr/2)-1][(Tc/2)-1] = '1';
		game[Tr/2][Tc/2] = '1';
		game[(Tr/2)-1][Tc/2] = '0';
		game[Tr/2][(Tc/2)-1] = '0';
		for(int i = 0;i<Tr;i++){
			System.out.print("|");
			for(int j = 0;j<Tc;j++){
				System.out.print(game[i][j] + "|");
			}
			System.out.println();
		}
		
		int row,col;
		int count = 0;
		char player = '0';
		int turn = 1;
		while(count < (Tc*Tr)){
			turn = player - '0' + 1;
			System.out.println("Player " + (turn) + " turn");
			System.out.print("Enter the row number(indexed 1): ");
			row = sc.nextInt();
			System.out.print("Enter the Column number(indexed 1): ");
			col = sc.nextInt();
			System.out.println();
			if(game[row-1][col-1] != ' '){
				System.out.println("Illegal Move");
			}else{
				game[row-1][col-1] = player;
				int changed = update(row,col,player,true);
				if(changed > 0){
					for(int i = 0;i<Tr;i++){
						System.out.print("|");
						for(int j = 0;j<Tc;j++){
							System.out.print(game[i][j] + "|");
						}
						System.out.println();
					}
					if(player == '0'){
						player = '1';
					}else{
						player = '0';
					}
					count++;
					if(check(player) == 1){
						if(player == '0'){
							player = '1';
						}else{
							player = '0';
						}
						if(check(player) == 1){
							break;
						}	
					}
				}else{
					game[row-1][col-1] = ' ';
					System.out.println("Illegal Move");
				}
			}
		}
		int black = 0;
		int white = 0;
		for(int i = 0;i<Tr;i++){
			for(int j = 0;j<Tc;j++){
				if(game[i][j] == '0'){
					black++;
				}else{
					white++;
				}
			}
		}
		if(black>white){
			System.out.println("Player 1 wins");
		}else if(black == white){
			System.out.println("Draw");
		}else{
			System.out.println("Player 2 wins");
		}
		System.out.println("Game ends");
	}
}
