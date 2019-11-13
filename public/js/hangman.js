let restartBtn = document.getElementById('restartBtn');

restartBtn.on('click', () => {
    let gameForm = document.getElementById('gameForm');

    let restart = document.createElement('input');

    restart.type('hidden').value('true');

    gameForm.appendChild(restart);
});