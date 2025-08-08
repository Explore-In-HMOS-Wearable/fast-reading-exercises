export interface TableCell {
  number: number;
  isFound: boolean;
  isHighlighted: boolean;
  effect: 'none' | 'success' | 'fail' | 'pulse' | 'shake';
  id: number;
}

@Observed
export class SchulteTableLogic {

  tableData: TableCell[][] = [];
  currentTarget: number = 1;
  gameStarted: boolean = false;
  gameCompleted: boolean = false;
  startTime: number = 0;
  elapsedTime: number = 0;
  level: number = 1;
  score: number = 0;
  message: string = '';
  mistakes: number = 0;
  timeLimit: number = 60;
  timeLeft: number = 60;
  combo: number = 0;
  maxCombo: number = 0;
  gridSize: number = 3;
  totalCells: number = 12;
  timerId: number = -1;
  timeoutId: number = -1;
  updateTrigger: number = 0;


  initializeGame(): void {
    this.gameStarted = false;
    this.gameCompleted = false;
    this.currentTarget = 1;
    this.elapsedTime = 0;
    this.mistakes = 0;
    this.combo = 0;
    this.message = '';
    this.calculateLevelSettings();
    this.clearTimer();
    this.clearTimeout();
    this.generateTable();
    this.updateTrigger++;
  }

   calculateLevelSettings(): void {
    if (this.level <= 2) {
      this.gridSize = 3;
      this.totalCells = 12;
      this.timeLimit = 35;
    } else if (this.level <= 4) {
      this.gridSize = 4;
      this.totalCells = 16;
      this.timeLimit = 45;
    } else if (this.level <= 6) {
      this.gridSize = 4;
      this.totalCells = 20;
      this.timeLimit = 55;
    } else if (this.level <= 8) {
      this.gridSize = 5;
      this.totalCells = 25;
      this.timeLimit = 65;
    } else {
      this.gridSize = 5;
      this.totalCells = 30;
      this.timeLimit = 75;
    }
    this.timeLeft = this.timeLimit;
  }

   generateTable(): void {
    const numbers: number[] = [];
    for (let i = 1; i <= this.totalCells; i++) {
      numbers.push(i);
    }

    for (let i = numbers.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = numbers[i];
      numbers[i] = numbers[j];
      numbers[j] = temp;
    }

    this.tableData = [];
    const cols = this.gridSize <= 3 ? 4 : this.gridSize <= 4 ? 4 : this.totalCells <= 25 ? 5 : 6;
    const rows = Math.ceil(this.totalCells / cols);

    for (let row = 0; row < rows; row++) {
      const rowData: TableCell[] = [];
      for (let col = 0; col < cols; col++) {
        const index = row * cols + col;
        if (index < this.totalCells) {
          rowData.push({
            number: numbers[index],
            isFound: false,
            isHighlighted: false,
            effect: 'none',
            id: index
          });
        }
      }
      if (rowData.length > 0) {
        this.tableData.push(rowData);
      }
    }
  }

  startGame(): void {
    this.gameStarted = true;
    this.startTime = Date.now();
    this.startTimer();
    this.message = `Find number ${this.currentTarget} to begin!`;
  }

  nextLevel(): void {
    this.level++;
    this.initializeGame();
  }

  restartGame(): void {
    this.level = 1;
    this.score = 0;
    this.maxCombo = 0;
    this.initializeGame();
  }

  onCellClick(row: number, col: number): void {
    if (this.gameCompleted || !this.gameStarted || this.timeLeft <= 0) {
      return;
    }

    const cell = this.tableData[row][col];
    if (cell.isFound) {
      return;
    }

    if (cell.number === this.currentTarget) {
      this.handleCorrectAnswer(cell);
    } else {
      this.handleWrongAnswer(cell);
    }
  }

  handleCorrectAnswer(cell: TableCell): void {
    cell.isFound = true;
    this.combo++;
    this.maxCombo = Math.max(this.maxCombo, this.combo);

    const basePoints = 10;
    const levelMultiplier = this.level;
    const comboBonus = this.combo > 1 ? this.combo * 5 : 0;
    const timeBonus = this.timeLeft > 30 ? 5 : 0;

    const points = basePoints + levelMultiplier + comboBonus + timeBonus;
    this.score += points;

    this.triggerCellEffect(cell, 'success');
    this.currentTarget++;

    if (this.currentTarget > this.totalCells) {
      this.completeLevel();
    } else {
      this.message = `✅ Correct! +${points} points`;
      this.clearMessageAfterDelay();
    }

    this.updateTrigger++;
  }

  handleWrongAnswer(cell: TableCell): void {
    this.mistakes++;
    this.combo = 0;
    this.score = Math.max(0, this.score - 5);

    this.triggerCellEffect(cell, 'fail');
    this.message = `❌ Wrong! (-5 points)`;
    this.clearMessageAfterDelay();

    this.updateTrigger++;
  }

  completeLevel(): void {
    this.gameCompleted = true;
    this.clearTimer();

    const timeBonus = Math.floor(this.timeLeft * 2);
    const levelBonus = this.level * 50;
    const comboBonus = this.maxCombo * 10;

    this.score += timeBonus + levelBonus + comboBonus;

    this.message = `🎉 Level ${this.level} Complete! +${timeBonus + levelBonus + comboBonus} bonus!`;

    setTimeout(() => {
      this.nextLevel();
    }, 1000);
  }

  triggerCellEffect(cell: TableCell, effect: 'success' | 'fail'): void {
    cell.effect = 'none';
    this.updateTrigger++;

    setTimeout(() => {
      if (effect === 'success') {
        cell.effect = 'pulse';
      } else {
        cell.effect = 'shake';
      }
      this.updateTrigger++;

      setTimeout(() => {
        cell.effect = 'none';
        this.updateTrigger++;
      }, 600);
    }, 50);
  }

  startTimer(): void {
    this.timerId = setInterval(() => {
      if (this.timeLeft > 0 && this.gameStarted && !this.gameCompleted) {
        this.timeLeft--;
        this.elapsedTime++;

        if (this.timeLeft <= 0) {
          this.timeUp();
        }
      }
    }, 1000);
  }

  timeUp(): void {
    this.gameStarted = false;
    this.clearTimer();
    this.message = '';
    this.score = Math.max(0, this.score - 20);
  }

  clearTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  clearTimeout(): void {
    if (this.timeoutId !== -1) {
      clearTimeout(this.timeoutId);
      this.timeoutId = -1;
    }
  }

  clearMessageAfterDelay(): void {
    this.clearTimeout();
    this.timeoutId = setTimeout(() => {
      this.message = '';
    }, 2000);
  }

  getCellBackgroundColor(cell: TableCell): string {
    if (cell.effect === 'pulse') {
      return '#fff3e0';
    }
    if (cell.effect === 'success' || cell.isFound) {
      return '#e8f5e8';
    }
    if (cell.effect === 'fail' || cell.effect === 'shake') {
      return '#ffebee';
    }
    return '#ffffff';
  }

  getCellFontColor(cell: TableCell): string {
    if (cell.isFound) {
      return '#27ae60';
    }
    if (cell.effect === 'pulse') {
      return '#ff9800';
    }
    if (cell.effect === 'fail' || cell.effect === 'shake') {
      return '#f44336';
    }
    return '#2c3e50';
  }

  getCellBorderColor(cell: TableCell): string {
    if (cell.effect === 'pulse') {
      return '#ff9800';
    }
    if (cell.effect === 'success' || cell.isFound) {
      return '#4caf50';
    }
    if (cell.effect === 'fail' || cell.effect === 'shake') {
      return '#f44336';
    }
    return '#ddd';
  }

  getMessageColor(): string {
    if (this.message.includes('Complete') || this.message.includes('✅')) {
      return '#27ae60';
    }
    if (this.message.includes('❌') || this.message.includes('Time\'s up')) {
      return '#e74c3c';
    }
    return '#007AFF';
  }



  getMessageBackgroundColor(): string {
    if (this.message.includes('Complete') || this.message.includes('✅')) {
      return '#e8f5e8';
    }
    if (this.message.includes('❌') || this.message.includes('Time\'s up')) {
      return '#ffebee';
    }
    return '#e3f2fd';
  }

}
