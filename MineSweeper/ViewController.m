//  Tyler Crabtree
//  Final project
//  ViewController.m
//  MineSweeper
//  crabtree.tyler@gmail.com
//  Original code supplied by Wayne O. Cochran on 4/14/15.
//  Copyright (c) 2015 Wayne O. Cochran. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

//
// Scan the minefield model, and update
// the minefieldMatrix view.
//
int remaining = 0; // test values for score
int marker = 0;    // more test values for score
int score = 90;    // I orginially hardcoded the score in (test)
//int levelIndex = 0;


-(void)updateMinefieldMatrix {
    const int W = self.mineField.width;   // set the width for minesweeper.
    const int H = self.mineField.height; // set the height for minesweeper.
    for (int r = 0; r < H; r++)  // first for loop for  height
        for (int c = 0; c < W; c++) {  // second for loop for width.
            Cell *cell = [self.mineField cellAtRow:r Col:c]; // makes individual cell
            NSButtonCell *bcell = [self.minefieldMatrix cellAtRow:r column:c]; // forms button
            if (cell.exposed) {  // set up possible outcomes for exposing square
                if (cell.numSurroundingMines == 0){ // if cell is exposed and unfilled
                    bcell.image = nil; // set image to nothing
                    bcell.title = @""; // set title to blank
                }
                else{  // or fill in with an appropriate number
                bcell.image = nil;  // still set image as nil
                bcell.title = [NSString stringWithFormat:@"%d", cell.numSurroundingMines];  // but put appropriate number
                }
                bcell.state = NSOnState;
                bcell.enabled = NO;

            } else if (cell.marked) {   // ig the flag is marked
                [bcell setImage: _flagImage];  // put flag image
               // bcell.title = @"P";
            } else {
                [bcell setImage: nil];  // else set as null
                [bcell setType: NSTextCellType];  // associate type
                bcell.title = @"";  // set title as blank
                bcell.enabled = YES;  // enable cell
                bcell.state = NSOffState;  // turn off
            }
        }
}

-(int)findScore{  // function used for testing. not currently in use, but finds score nicely.
    score = [self.mineField unexposedCells];
    printf ("%d", score);
    return score;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bombImage = [NSImage imageNamed:@"bomb"];  // set up bomb
    self.flagImage = [NSImage imageNamed:@"flag"];  // set up flag
    self.mineField = [[MineField alloc] initWithWidth:(int) self.minefieldMatrix.numberOfColumns   // set minfield
                                               Height:(int) self.minefieldMatrix.numberOfRows
                                                Mines:10];
    if (marker == 0){
        [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i",  [self findScore]]];  // for score

        marker++;
    }
    [self updateMinefieldMatrix]; // update minfield.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)newGame:(id)sender {
    NSLog(@"newGame:");
    score = 90;
    marker = 0; // for score
    
    
    const int W = self.mineField.width;
    const int H = self.mineField.height;
    for (int r = 0; r < H; r++)
        for (int c = 0; c < W; c++) {
            Cell *cell = [self.mineField cellAtRow:r Col:c];
            NSButtonCell *bcell = [self.minefieldMatrix cellAtRow:r column:c];
    
        [bcell setImage: nil]; // for clearing cells
        [bcell setType: NSTextCellType];
        bcell.title = @""; // for blank tiles
          }
    [self.mineField reset];
    [self updateMinefieldMatrix];
    [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i",  [self findScore]]];  // for score

    // XXX update score
    
}

- (IBAction)levelSelected:(NSPopUpButton *)sender {  // this section doesn't work, I simply did the beginner level
    
        const NSInteger level = sender.indexOfSelectedItem;
        if (level == self.levelIndex)
            return; // no change
        self.levelIndex = level; // else record change
        static struct {
            int width, height, numMines;
        } levels[4] = {
            {10, 10, 10}, // 0 : beginner
            {20, 15, 50}, // 1 : intermediate
            {25, 18, 90}, // 2 : advanced
            {30, 20, 150} // 3 : expert
        };
        const int w = levels[level].width; // determine new minefield configuration
        const int h = levels[level].height;
        const int m = levels[level].numMines;
        //
        // Update minefield matrix and record change in size.
        // Update AutoLayout size constraints on minefield matrix.
        //
        const CGSize matrixSize = self.minefieldMatrix.frame.size;
        [self.minefieldMatrix renewRows: h columns: w];
        [self.minefieldMatrix sizeToCells];
        const CGSize newMatrixSize = self.minefieldMatrix.frame.size;
        const CGSize deltaSize = CGSizeMake(newMatrixSize.width - matrixSize.width,
                                            newMatrixSize.height - matrixSize.height);
        //self.matrixWidthConstraint.constant = newMatrixSize.width;
        //self.matrixHeightContraint.constant = newMatrixSize.height;
        //
        // Resize enclosing window according to size
        // of the minefield matrix.
        //
        NSRect windowFrame = self.view.window.frame;
        NSRect newWindowFrame = CGRectMake(windowFrame.origin.x,
                                           windowFrame.origin.y - deltaSize.height,
                                           windowFrame.size.width + deltaSize.width,
                                           windowFrame.size.height + deltaSize.height);
        [self.view.window setFrame:newWindowFrame display:YES animate:NO];
        //
        // Allocate a new minfield model and update the minefield
        // matrix cells.
        //
        self.mineField = [[MineField alloc] initWithWidth:w Height:h Mines:m];
        [self updateMinefieldMatrix];
        [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i", score]];
    }

-(void)rightClicked:(NSMatrix*)sender {
    NSLog(@"rightClicked:");
    const int row = (int) sender.selectedRow;
    const int col = (int) sender.selectedColumn;
    NSButtonCell *bcell = sender.selectedCell;
    Cell *cell = [self.mineField cellAtRow:row Col:col];
    cell.marked = !cell.marked;
    if (cell.marked){
        [bcell setImage: _flagImage];        // for getting a flag
        score = [self.mineField unexposedCells];
        [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i", score]];

    }
    else{
        [bcell setImage: nil];  // else unmark the flag
        [bcell setType: NSTextCellType];
        bcell.title = @"";  // for title
        score = [self.mineField unexposedCells];
        [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i", score]];

        [self.minefieldMatrix deselectSelectedCell];
    }
}

- (IBAction)minefieldMatrixCellSelected:(NSMatrix *)sender {
    const int row = (int) sender.selectedRow;
    const int col = (int) sender.selectedColumn;
    NSLog(@"minefieldMatrixCellSelected: row=%d, col=%d", (int) row, (int)col);
    
    BOOL shiftKeyDown = ([[NSApp currentEvent] modifierFlags] &
                         (NSShiftKeyMask | NSAlphaShiftKeyMask)) !=0;
    
    Cell *cell = [self.mineField cellAtRow:row Col:col];
    NSButtonCell *bcell = [self.minefieldMatrix cellAtRow:row column:col];
    
    if (shiftKeyDown) { // user is marking a mine
        [self rightClicked:sender];
        return;
    }
    
    const int v = [self.mineField exposeCellAtRow:row Col:col];
  

    if (v == -1) {
        // BOOM!
        int count = 0;
        self.minefieldMatrix.enabled = NO;
        [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%s","BOOM"]];
        [bcell setImage: _bombImage];
        const int W = self.mineField.width;
        const int H = self.mineField.height;
        for (int r = 0; r < H; r++)
            for (int c = 0; c < W; c++) {
                //const int v = [self.mineField exposeCellAtRow:row Col:col];
                Cell *cell = [self.mineField cellAtRow:r Col:c];
                NSButtonCell *bcell = [self.minefieldMatrix cellAtRow:r column:c];
                //cell.exposed;
               // Cell *cell = [self cellAtRow: r Col: c]
                //    if ( [bcell.title  isEqual: @""]) {   // random code I tried until i got it right
                if (cell.hasMine) {  // if cell has mine expose all bombs

                //if (self.mineField cell.hasMine){
                        
                    [bcell setImage: _bombImage]; // expose bombds
                }
                else if ((count = [cell numSurroundingMines]) > 0){ // show numbers
                    bcell.image = nil;
                    bcell.title = [NSString stringWithFormat:@"%d", count];
                }
                else{  // else show blank
                    bcell.image = nil;
                    bcell.title = @"";
                }
                
            }
        
       // bcell.title = @"X";
        
        
        // XXX
    } else if (v == 0) { // multiple cell safely exposed

        [self updateMinefieldMatrix];
        remaining = [self.mineField unexposedCells];
        score = [self.mineField unexposedCells];

            if (score == 0){  // check if score is zero for win
                [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%s","WIN"]];
                self.minefieldMatrix.enabled = NO;
            }
            else{
                [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i", score]]; // else just show score
            }
        
    } else if (1 <= v && v <= 8) { // a single cell safely exposed
            [self updateMinefieldMatrix]; // only need to update one bcell

            score = [self.mineField unexposedCells];  // reset score

                if (score == 0){
        
                    [ self.scoreTextField setStringValue:[NSString stringWithFormat:@"%s","WIN"]];  // win case
                    self.minefieldMatrix.enabled = NO;
    
                    }
                else{
                    [self.scoreTextField setStringValue:[NSString stringWithFormat:@"%i", score]];  // else post the score score
                }
    } else {
        NSLog(@"Exposed cell already exposed");
    }
    
}

@end
