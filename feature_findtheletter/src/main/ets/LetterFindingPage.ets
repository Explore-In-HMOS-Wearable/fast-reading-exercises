import { Logger } from 'commons_library';
import { LetterCell } from './LetterCell';
import { LetterFindingLogic } from './LetterFindingLogic';


@Builder
export function LetterFindingPageBuilder(name: string, param: Object) {
  LetterFindingPage()
}

@Component
export struct LetterFindingPage {
  @State viewModel:LetterFindingLogic = new LetterFindingLogic()
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.viewModel.level = 1;
    this.viewModel.score = 0;
    this.viewModel.maxLettersInGrid = 9;
    this.viewModel.initGame();
  }

  aboutToDisappear(): void {
    if (  this.viewModel.messageTimer !== -1) {
      clearTimeout( this.viewModel.messageTimer);
    }
    if ( this.viewModel.timeTimer !== -1) {
      clearInterval( this.viewModel.timeTimer);
    }
  }

  build() {

    NavDestination() {

      Column() {
        Text(`Level: ${ this.viewModel.level}`)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007AFF')

        Text(`Time: ${ this.viewModel.timeLeft}s`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor( this.viewModel.timeLeft <= 10 ? '#FF4444' : '#FF6B35')
          .margin({ top: 3 })

        Row() {
          Text('Find The Letters')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
            .margin({ top: 5, bottom: 5 })

          Blank().width('5%')

          Text( this.viewModel.targetLetter.toUpperCase())
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
            .width(29)
            .height(29)
            .textAlign(TextAlign.Center)
            .backgroundColor('#f0f8ff')
            .border({ width: 4, color: '#007AFF' })
            .borderRadius(20)
        }

        Blank().height(7)

        Grid() {
          ForEach( this.viewModel.letterGrid, (cell: LetterCell, index: number) => {
            GridItem() {
              Row() {
                Text(cell.isVisible ? cell.letter.toUpperCase() : '')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .height('100%')
                  .backgroundColor( this.viewModel.getCellBackgroundColor(cell))
                  .border({
                    width: 2,
                    color:  this.viewModel.getCellBorderColor(cell)
                  })
                  .borderRadius(12)
                  .opacity(cell.isVisible ? 1 : 0.3)
                  .fontColor(Color.Black)
                  .translate({ x: cell.shake, y: 0 })
                  .scale({
                    x: cell.effect === 'shine' ? 1.1 : 1.0,
                    y: cell.effect === 'shine' ? 1.1 : 1.0
                  })
                  .animation({
                    duration: cell.effect === 'shine' ? 100 : 50,
                    curve: Curve.EaseInOut,
                    iterations: cell.effect === 'shine' ? 2 : 1,
                    playMode: cell.effect === 'shine' ? PlayMode.Alternate : PlayMode.Normal
                  })
                  .onClick(() =>  this.viewModel.checkLetter(index))
              }
            }
          }, (cell: LetterCell) => `cell_${cell.id}_${ this.viewModel.updateTrigger}`)
        }
        .columnsTemplate( this.viewModel.getColumnsTemplate())
        .rowsTemplate( this.viewModel.getRowsTemplate())
        .columnsGap(12)
        .rowsGap(12)
        .width('94%')
        .padding({left:8,right:8,top:3,bottom:3})
        .height( this.viewModel.maxLettersInGrid <= 12 ? 100 : 120)

        if ( this.viewModel.message !== '') {
          Text( this.viewModel.message)
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor( this.viewModel.getMessageColor())
            .padding(15)
            .backgroundColor( this.viewModel.getMessageBackgroundColor())
            .borderRadius(12)
            .margin({ top: 2, bottom:10})

            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f8f9fa')
      .padding(5)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)

    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack
      Logger.info('current page config info is ' + JSON.stringify(context.getConfigInRouteMap()));
    })

  }


}