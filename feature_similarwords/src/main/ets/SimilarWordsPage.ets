import { Logger } from 'commons_library';
import { SimilarWordsLogic, WordGroup } from './SimilarWordsLogic';


@Builder
export function SimilarWordsPageBuilder(name: string, param: Object) {
  SimilarWordsPage()
}

@Component
export struct SimilarWordsPage {

  @State viewmodel: SimilarWordsLogic = new SimilarWordsLogic()

  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.viewmodel.initGame();
  }

  aboutToDisappear(): void {
    this.viewmodel.clearTimer();
    this.viewmodel.clearMessageTimer();
  }

  build() {

    NavDestination() {

      Column({ space: 8 }) {
        // Compact Header
        Row({ space: 6 }) {
          Text(`L${this.viewmodel.level}`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
            .padding(3)
            .backgroundColor('#f0f8ff')
            .borderRadius(6)

          Text(`${this.viewmodel.timeLeft}s`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.viewmodel.timeLeft <= 3 ? '#FF4444' : '#FF6B35')
            .padding(3)
            .backgroundColor(this.viewmodel.timeLeft <= 3 ? '#ffebee' : '#fff3e0')
            .borderRadius(6)

          Text(`${this.viewmodel.score}`)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#27ae60')
            .padding(3)
            .backgroundColor('#e8f5e8')
            .borderRadius(6)
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({top:5})
        .width('50%')


        Row({ space: 6 }) {
          Text('Find Different Pair')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1a237e')

          if (this.viewmodel.streak > 1) {
            Text(`🔥 x${this.viewmodel.streak}`)
              .fontSize(9)
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
              .border({ width: 1, color: '#FF6B35' })
          }

        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('70%')


        // Compact Word Grid
        Grid() {
          ForEach(this.viewmodel.wordGroups, (group: WordGroup, index: number) => {
            GridItem() {
              Column({ space: 5 }) {

                Text(group.word1)
                  .fontSize(11)
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .height(12)
                  .borderRadius(4)
                  .fontColor(this.viewmodel.getWordFontColor(group))

                Text(group.word2)
                  .fontSize(11)
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .height(12)
                  .borderRadius(4)
                  .fontColor(this.viewmodel.getWordFontColor(group))

              }
              .justifyContent(FlexAlign.SpaceAround)
              .width('100%')
              .height(35)
              .backgroundColor(this.viewmodel.getRowBackgroundColor(group, index))
              .borderRadius(8)
              .padding(1)
              .border({
                width: 1,
                color: this.viewmodel.getRowBorderColor(group, index)
              })
              .scale({
                x: group.effect === 'pulse' ? 1.05 : group.effect === 'wrong' ? 0.95 : 1.0,
                y: group.effect === 'pulse' ? 1.05 : group.effect === 'wrong' ? 0.95 : 1.0
              })
              .rotate({
                angle: group.effect === 'wrong' ? (Math.random() - 0.5) * 4 : 0
              })
              .animation({
                duration: group.effect === 'pulse' ? 400 : 200,
                curve: Curve.EaseInOut,
                iterations: group.effect === 'pulse' ? 2 : 1,
                playMode: PlayMode.Alternate
              })
              .onClick(() => this.viewmodel.checkAnswer(index))
            }
          }, (group: WordGroup) => `group_${group.id}_${this.viewmodel.updateTrigger}`)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
        .columnsGap(7)
        .rowsGap(7)
        .padding({left:5,right:5})
        .width('90%')
        .height('55%')


        Row({ space: 6 }) {


          // Game Status
          if (this.viewmodel.gameActive && this.viewmodel.gameStarted) {
            Row() {
              Text('⏱️')
                .fontSize(13)
              Text(`${this.viewmodel.timeLeft}s left`)
                .fontSize(12)
                .fontColor(this.viewmodel.timeLeft <= 3 ? '#FF4444' : '#666')
                .fontWeight(FontWeight.Medium)
            }
          }

          // Completion Stats
          if (!this.viewmodel.gameActive && this.viewmodel.level > 1) {
            Column({ space: 2 }) {
              Text(`Level ${this.viewmodel.level - 1} Complete!`)
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor('#27ae60')


            }
            .padding(6)
            .backgroundColor('#e8f5e8')
            .borderRadius(8)
            .width('45%')
          }

          // Action Button
          if (!this.viewmodel.gameActive) {
            Button(this.viewmodel.level === 1 ? 'Start' : 'Next Level')
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor('#fff')
              .backgroundColor(this.viewmodel.level === 1 ? '#007AFF' : '#27ae60')
              .borderRadius(8)
              .height('25vp')
              .padding({
                top: 6,
                bottom: 6,
                left: 12,
                right: 12
              })
              .onClick(() => this.viewmodel.level === 1 ? this.viewmodel.startGame() : this.viewmodel.nextLevel())
          }

          // Message Section
          if (this.viewmodel.message !== '') {
            Text(this.viewmodel.message)
              .fontSize(8)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.viewmodel.getMessageColor())
              .textAlign(TextAlign.Center)
              .padding(4)
              .backgroundColor(this.viewmodel.getMessageBackgroundColor())
              .borderRadius(6)
              .width('60%')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }


        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('65%')
        .height('25vp')

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f8f9fa')
      .padding(6)
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