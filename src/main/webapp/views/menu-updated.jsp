<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${restaurant.name} - Menu</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <style>
                        :root {
                            --theme-color: #28a745;
                        }

                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        body {
                            background-color: #f8f9fa;
                            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        }

                        .restaurant-header {
                            background: linear-gradient(135deg, var(--theme-color) 0%, #2c3e50 100%);
                            color: white;
                            padding: 2rem 0;
                            margin-bottom: 2rem;
                        }

                        .restaurant-logo {
                            width: 100px;
                            height: 100px;
                            object-fit: cover;
                            border-radius: 50%;
                            border: 4px solid white;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        }

                        .restaurant-info h1 {
                            font-weight: bold;
                            margin-bottom: 0.5rem;
                        }

                        .badge-status {
                            padding: 0.5rem 1rem;
                            font-size: 0.9rem;
                        }

                        .category-section {
                            margin-bottom: 3rem;
                        }

                        .category-title {
                            color: var(--theme-color);
                            font-weight: bold;
                            font-size: 1.8rem;
                            margin-bottom: 1.5rem;
                            padding-bottom: 0.5rem;
                            border-bottom: 3px solid var(--theme-color);
                        }