import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

private int NUM_COLS = 10;
private int NUM_ROWS = 10;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    mines = new ArrayList<MSButton>();

    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < buttons.length; ++i) {
        for (int j = 0; j < buttons[0].length; ++j) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    
    setMines();
}
public void setMines()
{
    for (int i = 0; i < 10; ++i) {
        int indexX = (int)(Math.random() * buttons.length);
        int indexY = (int)(Math.random() * buttons.length);
        if (mines.contains(buttons[indexX][indexY])) {
            i--;
            continue;
        }
        mines.add(buttons[indexX][indexY]);
    }
}

public void draw ()
{
    background(0);
    if (isLost()) {
        displayLosingMessage();
    } else if(isWon()) {
        displayWinningMessage();
    }
    for (int i = 0; i < buttons.length; ++i) {
        for (int j = 0; j < buttons[0].length; ++j) {
            buttons[i][j].draw();
        }
    }
}
public boolean isWon()
{
    for (int i = 0; i < buttons.length; ++i) {
        for (int j = 0; j < buttons[i].length; ++j) {
            if (!buttons[i][j].isClicked() && !mines.contains(buttons[i][j])) {
                return false;
            }
        }
    }
    return true;
}

public boolean isLost() {
    for (int i = 0; i < mines.size(); i++) {
        if (mines.get(i).isClicked()) {
            return true;
        }
    }
    return false;
}

public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) {
        mines.get(i).mousePressed();
    }
    buttons[5][1].setLabel("Y");
    buttons[5][2].setLabel("O");
    buttons[5][3].setLabel("U");
    buttons[5][4].setLabel(" ");
    buttons[5][5].setLabel("L");
    buttons[5][6].setLabel("O");
    buttons[5][7].setLabel("S");
    buttons[5][8].setLabel("T");
}
public void displayWinningMessage()
{
    background(0);
    for (int i = 0; i < mines.size(); i++) {
        mines.get(i).setFlagged(true);
    }
    buttons[5][1].setLabel("Y");
    buttons[5][2].setLabel("O");
    buttons[5][3].setLabel("U");
    buttons[5][4].setLabel(" ");
    buttons[5][5].setLabel("W");
    buttons[5][6].setLabel("O");
    buttons[5][7].setLabel("N");
    buttons[5][8].setLabel("!");
}

public void keyPressed() {
    if (key == 'r') {
        setup();
    }
}

public boolean isValid(int r, int c)
{
    if (r < 0 || c < 0) return false;
    if (r >= buttons.length || c >= buttons[0].length) return false;
    return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (isValid(row+i-1, col+j-1) && mines.contains(buttons[row+i-1][col+j-1])) numMines++;
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if (clicked) return;
        if (mouseButton == RIGHT && !clicked) {
            flagged = !flagged;
            return;
        } else {
            clicked = true;
        }
        if (mines.contains(this)) {
            // displayLosingMessage();
        } else if (countMines(myRow, myCol) > 0) {
            setLabel(countMines(myRow, myCol));
        } else {
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    if (isValid(myRow+i-1, myCol+j-1) && !buttons[myRow+i-1][myCol+j-1].isClicked()) {
                        buttons[myRow+i-1][myCol+j-1].mousePressed();
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked() {
        return clicked;
    }
    public void setFlagged(boolean newFlag) {
        flagged = newFlag;
    }
}
