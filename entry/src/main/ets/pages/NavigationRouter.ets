import { LetterFindingPage } from 'feature_findtheletter';
import { LandingPage } from 'feature_landing';
import { ReadingAccelerator } from 'feature_readingaccelerator';
import { SchulteTablePage } from 'feature_schultetable';
import { SimilarWordsPage } from 'feature_similarwords';
import { SplashPage } from 'feature_splash';

@Entry
@Component
struct NavigationRouter {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()

  @Builder
  routerMap(builderName: string, param: object) {
    if (builderName === 'SplashPage') {
      SplashPage()
    } else if (builderName === 'LetterFindingPage') {
      LetterFindingPage()
    } else if (builderName === 'ReadingAccelerator') {
      ReadingAccelerator()
    } else if (builderName === 'SimilarWordsPage') {
      SimilarWordsPage()
    } else if (builderName === 'SchulteTablePage') {
      SchulteTablePage()
    } else if (builderName === 'LandingPage') {
      LandingPage()
    }
  }

  aboutToAppear() {
    this.pageInfos.pushPathByName('SplashPage', null);
  }

  build() {
    Navigation(this.pageInfos) {
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.routerMap)

  }
}

