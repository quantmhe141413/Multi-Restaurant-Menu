<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Multi-Restaurant Menu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #ff4757;
            --secondary: #2f3542;
            --light: #f1f2f6;
            --dark: #2f3542;
            --white: #ffffff;
            --shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--light);
            color: var(--dark);
        }

        .site-header {
            background-color: var(--white);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .site-header__bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--secondary);
            margin-left: 1.5rem;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-user {
            color: #57606f;
        }

        .nav-action {
            color: var(--primary);
            font-weight: 600;
        }

        .hero {
            padding: 4rem 5%;
            text-align: center;
            background: linear-gradient(135deg, var(--primary), #ff6b81);
            color: var(--white);
        }

        .search-container {
            margin-top: 2rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .search-container input,
        .search-container select {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 25px;
            outline: none;
        }

        .search-container input {
            min-width: 260px;
        }

        .search-container select {
            background-color: var(--white);
            color: var(--secondary);
        }

        .search-container button {
            padding: 0.8rem 2rem;
            border: none;
            background-color: var(--secondary);
            color: var(--white);
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-container button:hover {
            background-color: #000;
        }

        .container {
            max-width: 1200px;
            margin: 3rem auto;
            padding: 0 1rem;
        }

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .restaurant-card {
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: transform 0.3s;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
        }

        .restaurant-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background-color: #ddd;
        }

        .restaurant-info {
            padding: 1.5rem;
        }

        .restaurant-name {
            font-size: 1.25rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .restaurant-address {
            color: #747d8c;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .btn-view {
            display: inline-block;
            padding: 0.6rem 1.2rem;
            background-color: var(--primary);
            color: var(--white);
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: opacity 0.3s;
        }

        .btn-view:hover {
            opacity: 0.9;
        }

        .site-footer {
            background-color: var(--secondary);
            color: var(--white);
            padding: 1.5rem 5%;
            text-align: center;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<section class="hero">
    <h1>Discover the best food near you</h1>
    <form action="home" method="get" class="search-container" id="searchForm">
        <input type="text" name="search" placeholder="Search for restaurants..." value="${currentSearch}">
        <select name="zone" id="zoneSelect">
            <option value="">All areas</option>
            <c:forEach var="z" items="${zones}">
                <option value="${z}" <c:if test="${z == selectedZone}">selected</c:if>>${z}</option>
            </c:forEach>
        </select>
        <button type="submit"><i class="fas fa-search"></i> Search</button>
    </form>
</section>

<div class="container">
    <h2>Restaurants</h2>
    <div class="restaurant-grid">
        <c:forEach var="r" items="${restaurants}">
            <div class="restaurant-card">
                <img src="${r.logoUrl}" alt="${r.name}" class="restaurant-image" onerror="this.src='https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg'">
                <div class="restaurant-info">
                    <div class="restaurant-name">${r.name}</div>
                    <div class="restaurant-address"><i class="fas fa-map-marker-alt"></i> ${r.address}</div>
                    <a href="restaurant?id=${r.restaurantID}" class="btn-view">View Menu</a>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty restaurants}">
            <p>No restaurants found.</p>
        </c:if>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script>
document.addEventListener('DOMContentLoaded', function () {
    const zoneSelect = document.getElementById('zoneSelect');
    if (zoneSelect) {
        zoneSelect.addEventListener('change', function () {
            document.getElementById('searchForm').submit();
        });
    }
});
</script>

</body>
</html>
