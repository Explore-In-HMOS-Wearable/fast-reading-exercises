import { Logger } from 'commons_library';
import { SchulteTableLogic, TableCell } from './SchulteTableLogic';

@Builder
export function SchulteTablePageBuilder(name: string, param: Object) {
  SchulteTablePage()
}

@Component
export struct SchulteTablePage {
  @State viewModel : SchulteTableLogic = new SchulteTableLogic()
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.viewModel.initializeGame();
  }

  aboutToDisappear(): void {
    this.viewModel.clearTimer();
    this.viewModel.clearTimeout();
  }

  build() {

    NavDestination() {

      Column({ space: 2 }) {
        // Compact Header for Watch

        Blank().height(5)

        Row({ space: 8 }) {
          Text(`L${this.viewModel.level}`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
            .padding(4)
            .backgroundColor('#f0f8ff')
            .borderRadius(8)

          Text(`${this.viewModel.timeLeft}s`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.viewModel.timeLeft <= 10 ? '#FF4444' : '#FF6B35')
            .padding(4)
            .backgroundColor(this.viewModel.timeLeft <= 10 ? '#ffebee' : '#fff3e0')
            .borderRadius(8)

          Text(`${this.viewModel.score}`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#27ae60')
            .padding(4)
            .backgroundColor('#e8f5e8')
            .borderRadius(8)
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('50%')

        // Compact Target Display
        Row() {
          Text('Find:')
            .fontSize(11)
            .fontColor('#666')

          Text(`${this.viewModel.currentTarget}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
            .padding({
              left: 6,
              right: 6,
              top: 2,
              bottom: 2
            })
            .backgroundColor('#e3f2fd')
            .borderRadius(8)
            .border({ width: 1, color: '#007AFF' })
            .margin({left:3})

          if (this.viewModel.combo > 1) {
            Text(`🔥${this.viewModel.combo}`)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF6B35')
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
              .backgroundColor('#fff3e0')
              .borderRadius(8)
              .margin({left:2})
          }
        }
        .justifyContent(FlexAlign.Center)


        // Compact Game Grid for Watch
        Column({ space: this.viewModel.gridSize <= 3 ? 3 : 2 }) {
          ForEach(this.viewModel.tableData, (row: TableCell[], rowIndex: number) => {
            Row({ space: this.viewModel.gridSize <= 3 ? 3 : 2 }) {
              ForEach(row, (cell: TableCell, colIndex: number) => {
                Text(cell.number.toString())
                  .fontSize((this.viewModel.gridSize <= 3 ? 11 : this.viewModel.gridSize <= 4 ? 10 : 9) * 1.4)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width((this.viewModel.gridSize <= 3 ? 25 : this.viewModel.gridSize <= 4 ? 22 : 20) * 1.4)
                  .height((this.viewModel.gridSize <= 3 ? 25 : this.viewModel.gridSize <= 4 ? 22 : 20) * 1.4)
                  .backgroundColor(this.viewModel.getCellBackgroundColor(cell))
                  .fontColor(this.viewModel.getCellFontColor(cell))
                  .borderRadius(6)
                  .border({
                    width: 1,
                    color: this.viewModel.getCellBorderColor(cell)
                  })
                  .scale({
                    x: cell.effect === 'pulse' ? 1.1 : cell.effect === 'shake' ? 0.9 : 1.0,
                    y: cell.effect === 'pulse' ? 1.1 : cell.effect === 'shake' ? 0.9 : 1.0
                  })
                  .rotate({
                    angle: cell.effect === 'shake' ? (Math.random() - 0.5) * 8 : 0
                  })
                  .opacity(cell.isFound ? 0.7 : 1.0)
                  .animation({
                    duration: cell.effect === 'pulse' ? 300 : 200,
                    curve: Curve.EaseInOut,
                    iterations: cell.effect === 'pulse' ? 2 : 1,
                    playMode: PlayMode.Alternate
                  })
                  .onClick(() => this.viewModel.onCellClick(rowIndex, colIndex))
              }, (cell: TableCell) => `cell_${cell.id}_${this.viewModel.updateTrigger}`)
            }
            .justifyContent(FlexAlign.Center)
          }, (row: TableCell[]) => `row_${this.viewModel.updateTrigger}`)
        }
        .padding(8)
        .backgroundColor('#f8f9fa')
        .borderRadius(12)

        // Compact Message for Watch
        if (this.viewModel.message !== '') {
          Text(this.viewModel.message)
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.viewModel.getMessageColor())
            .textAlign(TextAlign.Center)
            .padding(6)
            .backgroundColor(this.viewModel.getMessageBackgroundColor())
            .borderRadius(8)
            .width('95%')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        // Compact Completion Stats for Watch
        if (this.viewModel.gameCompleted) {
          Column({ space: 4 }) {
            Text(`Level ${this.viewModel.level} ✓`)
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .fontColor('#27ae60')

            Row({ space: 8 }) {
              Text(`${this.viewModel.elapsedTime}s`)
                .fontSize(9)
                .fontColor('#666')
              Text(`x${this.viewModel.maxCombo}`)
                .fontSize(9)
                .fontColor('#FF6B35')
              Text(`${this.viewModel.mistakes} err`)
                .fontSize(9)
                .fontColor('#e74c3c')
            }
          }
          .padding(8)
          .backgroundColor('#e8f5e8')
          .borderRadius(8)
          .width('90%')
        }

        // Compact Action Buttons for Watch
        if (!this.viewModel.gameStarted || this.viewModel.gameCompleted || (!this.viewModel.gameStarted && this.viewModel.timeLeft <= 0)) {
          Row({ space: 6 }) {
            if (this.viewModel.gameCompleted) {
              Button(`Next`)
                .fontSize(11)
                .fontWeight(FontWeight.Bold)
                .fontColor('#fff')
                .backgroundColor('#27ae60')
                .borderRadius(8)
                .padding({
                  top: 6,
                  bottom: 6,
                  left: 12,
                  right: 12
                })
                .onClick(() => this.viewModel.nextLevel())
            } else {
              Button('Start')
                .fontSize(11)
                .fontWeight(FontWeight.Bold)
                .fontColor('#fff')
                .backgroundColor('#007AFF')
                .height('25vp')
                .borderRadius(8)
                .padding({
                  top: 6,
                  bottom: 6,
                  left: 12,
                  right: 12
                })
                .onClick(() => this.viewModel.startGame())
            }

            Button('🔄')
              .fontSize(13)
              .fontColor('#666')
              .backgroundColor('#f5f5f5')
              .border({ width: 1, color: '#ddd' })
              .borderRadius(8)
              .height('25vp')
              .padding({
                left: 8,
                right: 8
              })
              .onClick(() => this.viewModel.restartGame())
          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ffffff')
      .padding(4)
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