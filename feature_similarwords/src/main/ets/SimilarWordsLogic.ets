export interface WordGroup {
  word1: string;
  word2: string;
  isDifferent: boolean;
  effect: 'none' | 'correct' | 'wrong' | 'pulse';
  id: number;
}

@Observed
export class SimilarWordsLogic {

  wordGroups: WordGroup[] = [];
  timeLeft: number = 8;
  message: string = '';
  gameActive: boolean = true;
  gameStarted: boolean = false;
  wrongAnswerIndex: number = -1;
  level: number = 1;
  score: number = 0;
  streak: number = 0;
  maxStreak: number = 0;
  updateTrigger: number = 0;
  difficulty: 'easy' | 'medium' | 'hard' = 'easy';
  timerId: number = -1;
  messageTimer: number = -1;

  resetAllEffects(): void {
    for (let i = 0; i < this.wordGroups.length; i++) {
      this.wordGroups[i].effect = 'none';
    }
  }

  initGame(): void {
    this.gameActive = false;
    this.gameStarted = false;
    this.message = '';
    this.wrongAnswerIndex = -1;
    this.calculateDifficulty();
    this.clearTimer();
    this.clearMessageTimer();
    this.resetAllEffects();
    this.wordGroups = this.generateWordGroups();
    this.updateTrigger++;
  }

  calculateDifficulty(): void {
    if (this.level <= 3) {
      this.difficulty = 'easy';
      this.timeLeft = 8;
    } else if (this.level <= 6) {
      this.difficulty = 'medium';
      this.timeLeft = 6;
    } else {
      this.difficulty = 'hard';
      this.timeLeft = 5;
    }
  }

  generateWordGroups(): WordGroup[] {
    const easyWords = [
      'cat', 'dog', 'sun', 'moon', 'car', 'bus', 'red', 'blue', 'big', 'small',
      'hot', 'cold', 'run', 'walk', 'book', 'pen', 'cup', 'ball', 'fish', 'bird',
      'tree', 'leaf', 'box', 'bag', 'cake', 'milk', 'apple', 'egg', 'rain', 'snow'
    ];

    const mediumWords = [
      'house', 'horse', 'water', 'winter', 'hand', 'land', 'eye', 'sky',
      'heart', 'start', 'road', 'load', 'tree', 'free', 'light', 'night',
      'chair', 'stair', 'smile', 'while', 'bread', 'read', 'phone', 'stone',
      'green', 'clean', 'sleep', 'deep', 'brain', 'train', 'beach', 'teach',
      'money', 'honey', 'paper', 'tiger', 'music', 'magic', 'table', 'cable',
      'nurse', 'purse', 'clock', 'block', 'flower', 'power', 'silver', 'river'
    ];

    const hardWords = [
      'mountain', 'fountain', 'elephant', 'pleasant', 'computer', 'commuter',
      'brother', 'mother', 'teacher', 'preacher', 'kitchen', 'chicken',
      'building', 'wedding', 'birthday', 'holiday', 'student', 'present',
      'picture', 'nature', 'window', 'shadow', 'garden', 'burden', 'finger',
      'singer', 'doctor', 'actor', 'dancer', 'answer', 'butter', 'letter',
      'number', 'lumber', 'corner', 'border', 'carpet', 'target', 'season',
      'reason', 'blanket', 'basket', 'hammer', 'banner', 'marker', 'parker',
      'wonder', 'thunder', 'spider', 'cider', 'ladder', 'matter', 'father',
      'gather', 'weather', 'leather', 'feather', 'brother', 'another', 'bother'
    ];

    const wordList = this.difficulty === 'easy' ? easyWords :
      this.difficulty === 'medium' ? mediumWords : hardWords;

    const size = 9;
    const groups: WordGroup[] = [];
    const differentIndex = Math.floor(Math.random() * size);

    for (let i = 0; i < size; i++) {
      if (i === differentIndex) {
        const word1 = wordList[Math.floor(Math.random() * wordList.length)];
        let word2 = wordList[Math.floor(Math.random() * wordList.length)];

        while (word2 === word1) {
          word2 = wordList[Math.floor(Math.random() * wordList.length)];
        }

        groups.push({
          word1: word1,
          word2: word2,
          isDifferent: true,
          effect: 'none',
          id: i
        });
      } else {
        const word = wordList[Math.floor(Math.random() * wordList.length)];
        groups.push({
          word1: word,
          word2: word,
          isDifferent: false,
          effect: 'none',
          id: i
        });
      }
    }

    return groups;
  }

  startGame(): void {
    this.resetAllEffects();
    this.message = '';
    this.wrongAnswerIndex = -1;
    this.gameActive = true;
    this.gameStarted = true;
    this.updateTrigger++;
    this.startTimer();
  }

  nextLevel(): void {
    this.level++;
    this.resetAllEffects();
    this.initGame();
    this.startGame();
  }

  startTimer(): void {
    this.clearTimer();

    this.timerId = setInterval(() => {
      this.timeLeft--;
      if (this.timeLeft <= 0) {
        this.timeUp();
      }
    }, 1000);
  }

  timeUp(): void {
    this.gameActive = false;
    this.clearTimer();
    this.streak = 0;
    this.score = Math.max(0, this.score - 10);
    this.message = '';
    this.highlightCorrectAnswer();
    this.setMessageTimer();

    setTimeout(() => {
      this.initGame();
      this.startGame();
    }, 2500);
  }

  clearTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  clearMessageTimer(): void {
    if (this.messageTimer !== -1) {
      clearTimeout(this.messageTimer);
      this.messageTimer = -1;
    }
  }

  setMessageTimer(): void {
    this.clearMessageTimer();
    this.messageTimer = setTimeout(() => {
      this.message = '';
    }, 2000);
  }

  checkAnswer(index: number): void {
    if (!this.gameActive) {
      return;
    }

    this.gameActive = false;
    this.clearTimer();

    if (this.wordGroups[index].isDifferent) {
      this.handleCorrectAnswer(index);
    } else {
      this.handleWrongAnswer(index);
    }
  }

  handleCorrectAnswer(index: number): void {
    this.streak++;
    this.maxStreak = Math.max(this.maxStreak, this.streak);

    const basePoints = 20;
    const timeBonus = this.timeLeft * 5;
    const streakBonus = this.streak > 1 ? this.streak * 10 : 0;
    const levelBonus = this.level * 5;

    const points = basePoints + timeBonus + streakBonus + levelBonus;
    this.score += points;

    this.wordGroups[index].effect = 'correct';
    this.triggerEffect(index, 'pulse');

    this.message = ``;
    this.setMessageTimer();

    setTimeout(() => {
      this.nextLevel();
    }, 1000);

    this.updateTrigger++;
  }

  handleWrongAnswer(index: number): void {
    this.wrongAnswerIndex = index;
    this.streak = 0;
    this.score = Math.max(0, this.score - 5);

    this.wordGroups[index].effect = 'wrong';
    this.triggerEffect(index, 'wrong');

    this.message = '';
    this.highlightCorrectAnswer();
    this.setMessageTimer();

    setTimeout(() => {
      this.initGame();
      this.startGame();
    }, 2500);

    this.updateTrigger++;
  }

  triggerEffect(index: number, effect: 'pulse' | 'wrong'): void {
    this.wordGroups[index].effect = effect;
    this.updateTrigger++;

    setTimeout(() => {
      this.wordGroups[index].effect = 'none';
      this.updateTrigger++;
    }, 800);
  }

  highlightCorrectAnswer(): void {
    for (let i = 0; i < this.wordGroups.length; i++) {
      if (this.wordGroups[i].isDifferent) {
        this.wordGroups[i].effect = 'correct';
        break;
      }
    }
    this.updateTrigger++;
  }

  getRowBackgroundColor(group: WordGroup, index: number): string {
    if (group.effect === 'correct' || (!this.gameActive && group.isDifferent)) {
      return '#e8f5e8';
    }
    if (group.effect === 'wrong' || index === this.wrongAnswerIndex) {
      return '#ffebee';
    }
    if (group.effect === 'pulse') {
      return '#fff3e0';
    }
    return '#ffffff';
  }

  getRowBorderColor(group: WordGroup, index: number): string {
    if (group.effect === 'correct' || (!this.gameActive && group.isDifferent)) {
      return '#4caf50';
    }
    if (group.effect === 'wrong' || index === this.wrongAnswerIndex) {
      return '#f44336';
    }
    if (group.effect === 'pulse') {
      return '#ff9800';
    }
    return '#e0e0e0';
  }

  getWordFontColor(group: WordGroup): string {
    if (group.effect === 'correct') {
      return '#2e7d32';
    }
    if (group.effect === 'wrong') {
      return '#c62828';
    }
    if (group.effect === 'pulse') {
      return '#e65100';
    }
    return '#333';
  }

  getMessageColor(): string {
    if (this.message.includes('Correct') || this.message.includes('🎉')) {
      return '#27ae60';
    }
    if (this.message.includes('Wrong') || this.message.includes('Time\'s up')) {
      return '#e74c3c';
    }
    return '#007AFF';
  }

  getMessageBackgroundColor(): string {
    if (this.message.includes('Correct') || this.message.includes('🎉')) {
      return '#e8f5e8';
    }
    if (this.message.includes('Wrong') || this.message.includes('Time\'s up')) {
      return '#ffebee';
    }
    return '#e3f2fd';
  }
}