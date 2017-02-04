

#import <Cocoa/Cocoa.h>
#import "MineField.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSMatrix *minefieldMatrix;
@property (weak) IBOutlet NSTextField *scoreTextField;

- (IBAction)newGame:(id)sender;
- (IBAction)levelSelected:(NSPopUpButton *)sender;
- (IBAction)minefieldMatrixCellSelected:(NSMatrix *)sender;

@property (strong, nonatomic) MineField *mineField;

@property (strong, nonatomic) NSImage *bombImage;
@property (strong, nonatomic) NSImage *flagImage;
@property (assign, nonatomic) NSInteger levelIndex;
-(void)rightClicked:(NSMatrix*)sender;

@end

