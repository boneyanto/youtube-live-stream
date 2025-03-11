document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('form');
    form.addEventListener('submit', function (event) {
        const sessionNumber = document.getElementById('session_number').value;
        const url = document.getElementById('url').value;
        const key = document.getElementById('key').value;
        const duration = document.getElementById('duration').value;

        if (!sessionNumber || !url || !key || !duration) {
            alert('Semua field harus diisi!');
            event.preventDefault();
        }
    });
});