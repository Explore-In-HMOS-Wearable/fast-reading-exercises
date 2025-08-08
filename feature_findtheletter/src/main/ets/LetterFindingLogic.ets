import { LetterCell } from "./LetterCell";

@Observed
export class LetterFindingLogic{

  @Track targetLetter: string = '';
  @Track letterGrid: LetterCell[] = [];
  @Track foundLetters: number = 0;
  @Track totalTargetLetters: number = 0;
  @Track message: string = '';
  @Track gameActive: boolean = true;
  @Track score: number = 0;
  @Track messageTimer: number = -1;
  @Track updateTrigger: number = 0;
  @Track level: number = 1;
  @Track maxLettersInGrid: number = 12;
  @Track timeLeft: number = 30;
  @Track timeTimer: number = -1;
  @Track totalTime: number = 30;

  initGame(): void {
    this.gameActive = true;
    this.message = '';
    this.foundLetters = 0;
    this.totalTargetLetters = 0;
    this.clearMessageTimer();
    this.clearTimeTimer();
    this.calculateTimeLimit();
    this.updateTrigger++;
    this.generateLetterGame();
    this.startTimer();
  }

  generateLetterGame(): void {
    const letters: string[] = [
      'A', 'B', 'C', 'C', 'D', 'E', 'F', 'G', 'G', 'H',
      'I', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'O', 'P',
      'R', 'S', 'S', 'T', 'U', 'U', 'V', 'Y', 'Z'
    ];

    this.targetLetter = letters[this.getRandomNumber(0, letters.length - 1)];

    const newGrid: LetterCell[] = [];

    let targetCount = this.calculateTargetCount();
    this.maxLettersInGrid = this.calculateGridSize();
    this.totalTargetLetters = targetCount;

    for (let i = 0; i < targetCount; i++) {
      newGrid.push(new LetterCell(
        this.targetLetter,
        true,
        false,
        i,
        'none',
        0
      ));
    }

    const otherLetters: string[] = [];
    for (let i = 0; i < letters.length; i++) {
      if (letters[i] !== this.targetLetter) {
        otherLetters.push(letters[i]);
      }
    }

    const usedOtherLetters: string[] = [];

    for (let i = targetCount; i < this.maxLettersInGrid; i++) {
      let randomLetter: string;
      if (usedOtherLetters.length < otherLetters.length) {
        do {
          randomLetter = otherLetters[this.getRandomNumber(0, otherLetters.length - 1)];
        } while (this.arrayIncludes(usedOtherLetters, randomLetter));
        usedOtherLetters.push(randomLetter);
      } else {
        randomLetter = otherLetters[this.getRandomNumber(0, otherLetters.length - 1)];
      }

      newGrid.push(new LetterCell(
        randomLetter,
        true,
        false,
        i,
        'none',
        0
      ));
    }

    this.shuffleArray(newGrid);

    this.letterGrid = newGrid;
    this.updateTrigger++;
  }

  calculateTargetCount(): number {
    if (this.level <= 2) {
      return this.getRandomNumber(2, 3);
    }
    if (this.level <= 5) {
      return this.getRandomNumber(3, 4);
    }
    if (this.level <= 8) {
      return this.getRandomNumber(4, 5);
    }
    return this.getRandomNumber(5, 6);
  }

   calculateTimeLimit(): void {
    if (this.level <= 3) {
      this.totalTime = 30;
    } else if (this.level <= 6) {
      this.totalTime = 45;
    } else if (this.level <= 10) {
      this.totalTime = 60;
    } else {
      this.totalTime = 75;
    }
    this.timeLeft = this.totalTime;
  }

  startTimer(): void {
    this.timeTimer = setInterval(() => {
      if (this.timeLeft > 0 && this.gameActive) {
        this.timeLeft--;

        if (this.timeLeft <= 10 && this.timeLeft > 0) {
        }

        if (this.timeLeft <= 0) {
          this.timeUp();
        }
      }
    }, 1000);
  }

  timeUp(): void {
    this.gameActive = false;
    this.clearTimeTimer();
    this.message = '⏰ Time\'s up! Try again!';
    this.score = Math.max(0, this.score - 20);
  }

  clearTimeTimer(): void {
    if (this.timeTimer !== -1) {
      clearInterval(this.timeTimer);
      this.timeTimer = -1;
    }
  }

  calculateGridSize(): number {
    if (this.level <= 3) {
      return 9;
    }
    if (this.level <= 6) {
      return 12;
    }
    if (this.level <= 10) {
      return 15;
    }
    return 16;
  }

  getColumnsTemplate(): string {
    if (this.maxLettersInGrid <= 9) {
      return '1fr 1fr 1fr';
    }
    if (this.maxLettersInGrid <= 12) {
      return '1fr 1fr 1fr 1fr';
    }
    if (this.maxLettersInGrid <= 15) {
      return '1fr 1fr 1fr 1fr 1fr';
    }
    return '1fr 1fr 1fr 1fr';
  }

  getRowsTemplate(): string {
    if (this.maxLettersInGrid <= 9) {
      return '1fr 1fr 1fr';
    }
    if (this.maxLettersInGrid <= 12) {
      return '1fr 1fr 1fr';
    }
    if (this.maxLettersInGrid <= 15) {
      return '1fr 1fr 1fr';
    }
    return '1fr 1fr 1fr 1fr';
  }

  getRandomNumber(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  arrayIncludes(arr: string[], item: string): boolean {
    for (let i = 0; i < arr.length; i++) {
      if (arr[i] === item) {
        return true;
      }
    }
    return false;
  }

  shuffleArray(array: LetterCell[]): void {
    for (let i = array.length - 1; i > 0; i--) {
      const j = this.getRandomNumber(0, i);
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  updateCell(index: number, updates: LetterCell): void {
    const newGrid: LetterCell[] = [...this.letterGrid];
    newGrid[index] = updates;
    this.letterGrid = newGrid;
    this.updateTrigger++;
  }

  triggerCellEffect(index: number, effect: 'success' | 'fail' | 'shine') {
    const resetCell = this.letterGrid[index].update(
      undefined, undefined, undefined, undefined, 'none', 0
    );
    this.updateCell(index, resetCell);

    setTimeout(() => {
      if (effect === 'fail') {
        const failCell = this.letterGrid[index].update(
          undefined, undefined, undefined, undefined, 'fail', undefined
        );
        this.updateCell(index, failCell);
        this.startShakeAnimation(index);
      } else if (effect === 'success') {
        const shineCell = this.letterGrid[index].update(
          undefined, undefined, undefined, undefined, 'shine', undefined
        );
        this.updateCell(index, shineCell);

        setTimeout(() => {
          const successCell = this.letterGrid[index].update(
            undefined, undefined, undefined, undefined, 'success', undefined
          );
          this.updateCell(index, successCell);
        }, 400);
      }
    }, 50);
  }

  startShakeAnimation(index: number) {
    const shakeSequence: number[] = [-8, 8, -6, 6, -4, 4, -2, 2, 0];
    let step = 0;

    const shake = () => {
      if (step < shakeSequence.length && index < this.letterGrid.length) {
        const shakeCell = this.letterGrid[index].update(
          undefined, undefined, undefined, undefined, 'fail', shakeSequence[step]
        );
        this.updateCell(index, shakeCell);
        step++;
        setTimeout(shake, 80);
      } else {
        setTimeout(() => {
          if (index < this.letterGrid.length) {
            const resetCell = this.letterGrid[index].update(
              undefined, undefined, undefined, undefined, 'none', 0
            );
            this.updateCell(index, resetCell);
          }
        }, 300);
      }
    };

    shake();
  }

  checkLetter(index: number): void {
    if (!this.gameActive || !this.letterGrid[index].isVisible || this.letterGrid[index].isFound) {
      return;
    }

    const cell = this.letterGrid[index];

    if (cell.letter === this.targetLetter) {
      const foundCell = cell.update(undefined, undefined, true, undefined, undefined, undefined);
      this.updateCell(index, foundCell);

      this.foundLetters++;
      const levelBonus = this.level * 2;
      this.score += (10 + levelBonus);
      this.triggerCellEffect(index, 'success');

      if (this.foundLetters >= this.totalTargetLetters) {
        this.clearTimeTimer();
        const completionBonus = this.level * 25;
        const timeBonus = Math.floor(this.timeLeft * 2);
        this.score += (completionBonus + timeBonus);
        this.message = `🎉 Level ${this.level} Complete!
         ${completionBonus + timeBonus} bonus!`;
        this.gameActive = false;

        setTimeout(() => {
          this.nextLevel();
        }, 1000);
      } else {
        this.message = `✅ Correct! ${this.totalTargetLetters - this.foundLetters} letters left`;
        this.setMessageTimer();
      }
    } else {
      this.triggerCellEffect(index, 'fail');
      this.message = '❌ Wrong letter!';
      this.score = Math.max(0, this.score - 3);
      this.setMessageTimer();
    }
  }

  setMessageTimer(): void {
    this.clearMessageTimer();
    this.messageTimer = setTimeout(() => {
      this.message = '';
    }, 2000);
  }

  clearMessageTimer(): void {
    if (this.messageTimer !== -1) {
      clearTimeout(this.messageTimer);
      this.messageTimer = -1;
    }
  }

  startNewGame(): void {
    this.level = 1;
    this.score = 0;
    this.maxLettersInGrid = 9;
    this.initGame();
  }

  nextLevel(): void {
    this.level++;
    this.initGame();
  }

  restartCurrentLevel(): void {
    this.initGame();
  }

  restartGame(): void {
    this.level = 1;
    this.score = 0;
    this.maxLettersInGrid = 9;
    this.initGame();
  }

  isGameCompleted(): boolean {
    return this.foundLetters >= this.totalTargetLetters;
  }

  getCellBackgroundColor(cell: LetterCell): string {
    if (cell.effect === 'shine') {
      return '#fff3e0';
    }
    if (cell.effect === 'success' || cell.isFound) {
      return '#e8f5e8';
    }
    if (cell.effect === 'fail') {
      return '#ffebee';
    }
    if (cell.isVisible) {
      return '#ffffff';
    }
    return '#f0f0f0';
  }

  getCellBorderColor(cell: LetterCell): string {
    if (cell.effect === 'shine') {
      return '#ff9800';
    }
    if (cell.effect === 'success' || cell.isFound) {
      return '#4caf50';
    }
    if (cell.effect === 'fail') {
      return '#f44336';
    }
    if (cell.isVisible) {
      return '#ddd';
    }
    return '#f0f0f0';
  }

  getMessageColor(): string {
    if (this.message.includes('Congratulations') || this.message.includes('Correct') ||
    this.message.includes('Complete')) {
      return '#4caf50';
    }
    if (this.message.includes('Time\'s up')) {
      return '#FF6B35';
    }
    return '#f44336';
  }

  getMessageBackgroundColor(): string {
    if (this.message.includes('Congratulations') || this.message.includes('Correct') ||
    this.message.includes('Complete')) {
      return '#e8f5e8';
    }
    if (this.message.includes('Time\'s up')) {
      return '#fff3e0';
    }
    return '#ffebee';
  }
}