document.addEventListener('turbo:load', () => {
  const form = document.querySelector('form[action*="/diagnoses/step"]') || 
               document.querySelector('.diagnoses-card form');
  const loadingIndicator = document.getElementById('loading-indicator');

  // 結果ページの場合、ローディングを非表示にして終了
  if (!form && loadingIndicator) {
    loadingIndicator.classList.add('hidden');
    loadingIndicator.classList.remove('show');
    loadingIndicator.style.display = 'none';
    return;
  }

  // フォームまたはローディングインジケーターが見つからない場合は終了
  if (!form || !loadingIndicator) {
    return;
  }

  // フォーム送信時の処理
  form.addEventListener('submit', (event) => {
    const submitButton = event.submitter;

    // 最終ステップの判定
    if (submitButton && submitButton.dataset.final) {
      loadingIndicator.classList.remove('hidden');
      loadingIndicator.classList.add('show');
      loadingIndicator.style.display = 'flex';
    }
  });
});