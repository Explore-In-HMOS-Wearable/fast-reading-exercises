import { Logger } from 'commons_library';

@Builder
export function SplashPageBuilder(name: string, param: Object) {
  SplashPage()
}

@Entry
@Component
export struct SplashPage {
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    setTimeout(() => {
      this.pageInfos.pushPathByName('LandingPage', null);

    }, 1000)
  }

  build() {
    NavDestination() {
      Column({}) {

        Blank().height('27%')


        Column({ space: '15vp' }) {

          Image($r('app.media.icon_monochrome'))
            .width('55vp')
            .align(Alignment.Bottom)


        }

        Blank().height('9%')


        Text('Fast Reading \n Exercises')
          .fontColor('#cd000000')
          .fontWeight(FontWeight.Bold)

        Blank().height('25%')

      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('100%')

    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack
      Logger.info('current page config info is ' + JSON.stringify(context.getConfigInRouteMap()));
    })
  }
}
