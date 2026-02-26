<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
    body {
        font-family: 'Inter', sans-serif;
        background-color: #f8fafc;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    a {
        text-decoration: none;
    }

    .site-header {
        background-color: #ffffff;
        padding: 1rem 5%;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .site-header__bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .logo {
        font-size: 1.5rem;
        font-weight: 800;
        color: #ef4444;
        /* red-500 */
        letter-spacing: -0.025em;
    }

    .nav-links a {
        color: #475569;
        margin-left: 2rem;
        font-weight: 500;
        transition: color 0.2s;
    }

    .nav-links a:hover {
        color: #ef4444;
    }

    .nav-user {
        color: #64748b;
        margin-right: 1rem;
        font-size: 0.9rem;
    }

    .site-footer {
        background-color: #1e293b;
        color: #cbd5e1;
        padding: 2rem 0;
        margin-top: auto;
        text-align: center;
    }
</style>