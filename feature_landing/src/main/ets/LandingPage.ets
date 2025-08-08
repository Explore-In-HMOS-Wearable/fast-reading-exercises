import { router } from '@kit.ArkUI';
import { Logger } from 'commons_library';

@Builder
export function LandingPageBuilder(name: string, param: Object) {
  LandingPage()
}

@Entry
@Component
export struct LandingPage {
  pageInfos: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 4 }) {
          Column() {
            Text('Fast Reading Exercises')
              .fontSize(13)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                router.back()
              })

          }
          .width('100%')
          .padding({ top: 12 })
          .margin({ bottom: 5 })

          this.buildMenuItem('Find The Letter', $r('app.media.icon_monochrome'), Color.Blue, Color.White, Color.Blue,
            () => {
              this.pageInfos.pushPathByName('LetterFindingPage', null);
            })

          this.buildMenuItem('Accelerator', $r('app.media.bookiconss'), Color.Blue, Color.White, Color.Red, () => {
            this.pageInfos.pushPathByName('ReadingAccelerator', null);
          })

          this.buildMenuItem('Schulte Table', $r('app.media.tick'), Color.Blue, Color.White, Color.Green, () => {
            this.pageInfos.pushPathByName('SchulteTablePage', null);
          })

          this.buildMenuItem('Similar Words', $r('app.media.icon_cropped'), Color.Blue, Color.White, Color.Orange,
            () => {
              this.pageInfos.pushPathByName('SimilarWordsPage', null);
            })

          Blank().height(20)
        }
        .padding(12)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack
      Logger.info('current page config info is ' + JSON.stringify(context.getConfigInRouteMap()));
    })
  }

  @Builder
  buildMenuItem(label: string, icon: ResourceStr | string, iconColor: Color, textColor: Color, bgColor: Color,
    action: () => void) {
    Row({ space: 10 }) {
      if (icon) {

        Row() {
          Image(icon)
            .width(32)
            .height(12)
            .borderRadius(16)
        }
        .backgroundColor(iconColor)
        .borderRadius(16)
        .width(21)
        .visibility(Visibility.Hidden)
        .height(21)

      } else {
        Text('SOS')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .padding(4)
          .backgroundColor(Color.Red)
          .borderRadius(14)
      }

      Text(label)
        .fontSize(12)
        .fontColor(textColor)
        .fontWeight(FontWeight.Bold)
    }
    .padding({
      left: 8,
      right: 8,
      top: 6,
      bottom: 6
    })
    .backgroundColor(bgColor)
    .borderRadius(20)
    .width('80%')
    .onClick(action)
  }
}
