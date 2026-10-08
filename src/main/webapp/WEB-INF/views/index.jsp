<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere - Discover, Host & Experience Unforgettable Events</title>
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="landing-body">

    <!-- Top Sticky Glassmorphic Navbar -->
    <nav class="navbar navbar-expand-lg landing-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <span class="brand-icon-box me-2">
                    <i class="bi bi-calendar2-event-fill"></i>
                </span>
                <span class="brand-text">Event<span>Sphere</span></span>
            </a>
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#landingNav">
                <i class="bi bi-list fs-2 text-dark"></i>
            </button>
            <div class="collapse navbar-collapse" id="landingNav">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link landing-nav-link active" href="#explore">Explore Events</a></li>
                    <li class="nav-item"><a class="nav-link landing-nav-link" href="#categories">Categories</a></li>
                    <li class="nav-item"><a class="nav-link landing-nav-link" href="#how-it-works">How It Works</a></li>
                    <li class="nav-item"><a class="nav-link landing-nav-link" href="#stats">Impact</a></li>
                    <li class="nav-item"><a class="nav-link landing-nav-link" href="#faq">FAQ</a></li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser != null}">
                            <c:set var="dashUrl" value="/attendee/dashboard"/>
                            <c:if test="${sessionScope.currentUser.role == 'ADMIN'}"><c:set var="dashUrl" value="/admin/dashboard"/></c:if>
                            <c:if test="${sessionScope.currentUser.role == 'ORGANIZER'}"><c:set var="dashUrl" value="/organizer/dashboard"/></c:if>
                            <a href="${pageContext.request.contextPath}${dashUrl}" class="btn btn-primary d-inline-flex align-items-center shadow-sm">
                                <i class="bi bi-speedometer2 me-2"></i>My Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm" title="Logout">
                                <i class="bi bi-box-arrow-right"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary px-3 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Sign In
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary px-3 fw-semibold shadow-sm">
                                <i class="bi bi-stars me-1"></i>Get Started Free
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section with Animated Mesh & Interactive Search -->
    <header class="hero-section text-center position-relative overflow-hidden">
        <div class="hero-bg-orb orb-1"></div>
        <div class="hero-bg-orb orb-2"></div>
        <div class="hero-bg-orb orb-3"></div>

        <div class="container position-relative py-5">
            <div class="row justify-content-center">
                <div class="col-lg-10 col-xl-9">
                    <!-- Badge Pill -->
                    <div class="d-inline-flex align-items-center gap-2 hero-badge-pill mb-3">
                        <span class="badge bg-primary text-white rounded-pill px-2 py-1">NEW</span>
                        <span>Experience the Future of Event Ticketing & Management</span>
                        <i class="bi bi-arrow-right text-primary"></i>
                    </div>

                    <!-- Headline -->
                    <h1 class="display-3 fw-extrabold hero-headline mb-3">
                        Where Unforgettable Moments <span class="gradient-text">Come Alive</span>
                    </h1>
                    <p class="lead hero-subtext text-muted mb-4 mx-auto">
                        Discover top-tier tech summits, live music concerts, industry conferences, and hands-on workshops. 
                        Book instant digital QR passes or launch your own event in minutes.
                    </p>

                    <!-- Interactive Search & Filter Card -->
                    <div class="card hero-search-card shadow-lg border-0 mb-4 text-start">
                        <div class="card-body p-3 p-md-4">
                            <form id="heroFilterForm" onsubmit="event.preventDefault(); performSearch();" class="row g-2 align-items-center">
                                <div class="col-md-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-0 text-primary ps-2">
                                            <i class="bi bi-search fs-5"></i>
                                        </span>
                                        <input type="text" class="form-control border-0 shadow-none ps-1" id="searchKeyword" 
                                               placeholder="Search event name, topic or venue..." onkeyup="filterCardsRealtime()">
                                    </div>
                                </div>
                                <div class="col-md-3 border-start-md">
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-0 text-muted ps-2">
                                            <i class="bi bi-grid fs-5"></i>
                                        </span>
                                        <select class="form-select border-0 shadow-none ps-1" id="categoryFilter" onchange="filterCardsRealtime()">
                                            <option value="ALL">All Categories</option>
                                            <option value="Technology">Technology</option>
                                            <option value="Music">Music & Concerts</option>
                                            <option value="Business">Business & Networking</option>
                                            <option value="Workshops">Workshops & Learning</option>
                                            <option value="Sports">Sports & Fitness</option>
                                            <option value="Arts">Arts & Culture</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-3 hero-search-btn">
                                        <i class="bi bi-compass me-2"></i>Explore Events
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Popular Tags & Trust Indicators -->
                    <div class="d-flex flex-wrap align-items-center justify-content-center gap-2 popular-tags">
                        <span class="text-muted small fw-semibold">Popular Now:</span>
                        <button type="button" class="btn btn-sm btn-light rounded-pill tag-pill" onclick="quickFilter('Technology')">#TechSummit2024</button>
                        <button type="button" class="btn btn-sm btn-light rounded-pill tag-pill" onclick="quickFilter('Music')">#LiveMusicFest</button>
                        <button type="button" class="btn btn-sm btn-light rounded-pill tag-pill" onclick="quickFilter('Business')">#StartupPitch</button>
                        <button type="button" class="btn btn-sm btn-light rounded-pill tag-pill" onclick="quickFilter('Workshops')">#DesignWorkshop</button>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Interactive Category Filter Section -->
    <section class="py-4 bg-white border-top border-bottom" id="categories">
        <div class="container">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-3">
                <h4 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-funnel-fill text-primary me-2"></i>Filter by Category
                </h4>
                <div class="text-muted small">
                    <span id="eventsCountBadge" class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill">Showing All Events</span>
                </div>
            </div>
            <!-- Clickable Filter Pills -->
            <div class="d-flex gap-2 overflow-x-auto pb-2 category-pill-scroll" id="categoryPillContainer">
                <button type="button" class="btn category-pill-btn active" data-cat="ALL" onclick="selectCategoryPill('ALL', this)">
                    <i class="bi bi-stars me-1"></i>All Events
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Technology" onclick="selectCategoryPill('Technology', this)">
                    <i class="bi bi-laptop me-1"></i>Technology
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Music" onclick="selectCategoryPill('Music', this)">
                    <i class="bi bi-music-note-beamed me-1"></i>Music & Concerts
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Business" onclick="selectCategoryPill('Business', this)">
                    <i class="bi bi-briefcase me-1"></i>Business & Networking
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Workshops" onclick="selectCategoryPill('Workshops', this)">
                    <i class="bi bi-book me-1"></i>Workshops
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Arts" onclick="selectCategoryPill('Arts', this)">
                    <i class="bi bi-palette me-1"></i>Arts & Culture
                </button>
                <button type="button" class="btn category-pill-btn" data-cat="Sports" onclick="selectCategoryPill('Sports', this)">
                    <i class="bi bi-trophy me-1"></i>Sports & Fitness
                </button>
            </div>
        </div>
    </section>

    <!-- Upcoming & Featured Events Grid -->
    <section class="py-5 bg-light-subtle" id="explore">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-primary fw-bold text-uppercase tracking-wider small">Handpicked Experiences</span>
                    <h2 class="display-6 fw-bold mb-1">Featured & Upcoming Events</h2>
                    <p class="text-muted mb-0">Browse through high-energy conferences, concerts, and gatherings</p>
                </div>
            </div>

            <!-- Event Cards Container -->
            <div class="row g-4" id="eventsGrid">
                <c:choose>
                    <c:when test="${not empty upcomingEvents}">
                        <c:forEach items="${upcomingEvents}" var="event">
                            <div class="col-md-6 col-lg-4 event-item-card" 
                                 data-title="${event.title}" 
                                 data-category="${event.category != null ? event.category : 'Technology'}" 
                                 data-venue="${event.venue != null ? event.venue : 'Online'}">
                                <div class="card modern-event-card h-100 shadow-sm border-0">
                                    <div class="card-img-wrapper position-relative">
                                        <div class="event-banner-placeholder bg-gradient-primary">
                                            <i class="bi bi-calendar-event-fill display-4 text-white opacity-75"></i>
                                        </div>
                                        <span class="badge bg-dark bg-opacity-75 text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                            ${event.category != null ? event.category : 'General'}
                                        </span>
                                        <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                            <span class="d-block fw-extrabold text-primary fs-5 lh-1">${event.eventDate}</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column p-4">
                                        <h5 class="card-title fw-bold text-dark mb-2 text-truncate">${event.title}</h5>
                                        <p class="card-text text-muted small mb-3 flex-grow-1">${event.description}</p>
                                        <div class="event-meta-info mb-3 small text-muted">
                                            <div class="d-flex align-items-center mb-1">
                                                <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                                <span class="text-truncate">${event.venue}</span>
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-clock-fill text-primary me-2"></i>
                                                <span>${event.startTime} - ${event.endTime}</span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                    onclick="openQuickView('${event.title}', '${event.category}', '${event.eventDate}', '${event.venue}', '${event.description}')">
                                                <i class="bi bi-eye me-1"></i>Quick View
                                            </button>
                                            <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                                Book Ticket <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                </c:choose>

                <!-- Curated Interactive Showcase Events (Always Displayed & Interactive) -->
                <div class="col-md-6 col-lg-4 event-item-card" data-title="Global AI & Cloud Summit 2024" data-category="Technology" data-venue="San Francisco Convention Center & Hybrid">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-tech-gradient">
                                <i class="bi bi-cpu-fill display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-primary text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Technology
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">OCT</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">24</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-success-subtle text-success small fw-semibold"><i class="bi bi-fire me-1"></i>Trending</span>
                                <span class="fw-bold text-primary fs-5">$149.00</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">Global AI & Cloud Summit 2024</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                Join leading AI innovators, cloud architects, and tech founders exploring LLMs, agentic systems, and cloud infrastructure.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>San Francisco Convention Center</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>1,200 Attendees Registered</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Seats Filling Fast</span>
                                    <span class="fw-bold text-danger">88% Booked</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: 88%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('Global AI & Cloud Summit 2024', 'Technology', 'Oct 24, 2024', 'San Francisco Convention Center', 'Join leading AI innovators, cloud architects, and tech founders exploring LLMs, agentic systems, and high-performance infrastructure.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Reserve Pass <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4 event-item-card" data-title="Neon Nights Live Symphony Festival" data-category="Music" data-venue="Grand City Arena, Austin TX">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-music-gradient">
                                <i class="bi bi-music-note-beamed display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-purple text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Music
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">NOV</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">12</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-info-subtle text-info small fw-semibold"><i class="bi bi-headphones me-1"></i>Live Stage</span>
                                <span class="fw-bold text-primary fs-5">$65.00</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">Neon Nights Live Symphony Festival</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                An electrifying fusion of orchestral classical performances and cutting-edge electronic visual art.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>Grand City Arena, Austin TX</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>3,500 Music Enthusiasts</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Ticket Capacity</span>
                                    <span class="fw-bold text-warning">72% Booked</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: 72%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('Neon Nights Live Symphony Festival', 'Music', 'Nov 12, 2024', 'Grand City Arena, Austin TX', 'An electrifying fusion of orchestral classical performances and cutting-edge electronic visual art with world-class audio acoustics.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Get Tickets <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4 event-item-card" data-title="Founder & Venture Capital Connect" data-category="Business" data-venue="Manhattan Tech Hub, New York">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-business-gradient">
                                <i class="bi bi-briefcase-fill display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-success text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Business
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">NOV</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">28</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-primary-subtle text-primary small fw-semibold"><i class="bi bi-cash-stack me-1"></i>Angel & VC</span>
                                <span class="fw-bold text-success fs-5">Free Admission</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">Founder & Venture Capital Connect</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                Curated pitch opportunities for seed & Series A startups with active angel investors and fund partners.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>Manhattan Tech Hub, New York</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>400 Founders & Investors</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Seats</span>
                                    <span class="fw-bold text-success">45% Available</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 55%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('Founder & Venture Capital Connect', 'Business', 'Nov 28, 2024', 'Manhattan Tech Hub, New York', 'Curated pitch opportunities for seed & Series A startups with active angel investors and fund partners. Includes networking cocktail.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Register Free <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4 event-item-card" data-title="Modern UI/UX & Design Systems Bootcamp" data-category="Workshops" data-venue="Interactive Live Stream & Figma Studio">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-workshops-gradient">
                                <i class="bi bi-pencil-square display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-warning text-dark position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Workshops
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">DEC</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">05</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-warning-subtle text-warning small fw-semibold"><i class="bi bi-award me-1"></i>Certificate</span>
                                <span class="fw-bold text-primary fs-5">$49.00</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">Modern UI/UX & Design Systems Bootcamp</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                Master component tokens, accessible color systems, and modern micro-interactions in this intensive masterclass.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>Live Interactive Stream + Replay</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>250 Designers Registered</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Capacity</span>
                                    <span class="fw-bold text-primary">60% Booked</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 60%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('Modern UI/UX & Design Systems Bootcamp', 'Workshops', 'Dec 05, 2024', 'Live Interactive Stream & Figma Studio', 'Master component design tokens, accessible color systems, and modern micro-interactions in this intensive hands-on masterclass.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Join Workshop <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4 event-item-card" data-title="Contemporary Digital Arts Expo" data-category="Arts" data-venue="Metropolitan Cultural Gallery, Seattle">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-arts-gradient">
                                <i class="bi bi-palette-fill display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-danger text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Arts
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">DEC</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">15</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-danger-subtle text-danger small fw-semibold"><i class="bi bi-brush me-1"></i>Exhibition</span>
                                <span class="fw-bold text-primary fs-5">$25.00</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">Contemporary Digital Arts Expo</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                An interactive gallery showcasing generative art, VR sculptures, and digital media installations.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>Metropolitan Cultural Gallery, Seattle</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>800 Art Lovers</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Passes</span>
                                    <span class="fw-bold text-success">35% Booked</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 35%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('Contemporary Digital Arts Expo', 'Arts', 'Dec 15, 2024', 'Metropolitan Cultural Gallery, Seattle', 'An interactive gallery showcasing generative algorithmic art, VR sculptures, and digital media installations by 40+ artists.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    View Expo <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4 event-item-card" data-title="City Marathon & Wellness Expo 2025" data-category="Sports" data-venue="Riverside Park Promenade, Chicago">
                    <div class="card modern-event-card h-100 shadow-sm border-0">
                        <div class="card-img-wrapper position-relative">
                            <div class="event-banner-placeholder bg-sports-gradient">
                                <i class="bi bi-trophy-fill display-4 text-white opacity-75"></i>
                            </div>
                            <span class="badge bg-success text-white position-absolute top-0 end-0 m-3 px-3 py-2 rounded-pill category-badge">
                                Sports
                            </span>
                            <div class="date-badge-box position-absolute bottom-0 start-0 m-3 bg-white text-center rounded-3 p-2 shadow-sm">
                                <span class="d-block fw-bold text-muted small text-uppercase lh-1">JAN</span>
                                <span class="d-block fw-extrabold text-primary fs-4 lh-1">10</span>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="badge bg-success-subtle text-success small fw-semibold"><i class="bi bi-stopwatch me-1"></i>Timed 10k/Half</span>
                                <span class="fw-bold text-primary fs-5">$40.00</span>
                            </div>
                            <h5 class="card-title fw-bold text-dark mb-2">City Marathon & Wellness Expo 2025</h5>
                            <p class="card-text text-muted small mb-3 flex-grow-1">
                                Annual 5k, 10k, and Half-Marathon with chip timing, finisher medals, and health & nutrition booths.
                            </p>
                            <div class="event-meta-info mb-3 small text-muted">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                                    <span>Riverside Park Promenade, Chicago</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-people-fill text-info me-2"></i>
                                    <span>2,100 Runners Registered</span>
                                </div>
                            </div>
                            <div class="capacity-bar-box mb-3">
                                <div class="d-flex justify-content-between small text-muted mb-1">
                                    <span>Registration Cap</span>
                                    <span class="fw-bold text-danger">92% Full</span>
                                </div>
                                <div class="progress" style="height: 6px;">
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: 92%"></div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-auto">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="openQuickView('City Marathon & Wellness Expo 2025', 'Sports', 'Jan 10, 2025', 'Riverside Park Promenade, Chicago', 'Annual 5k, 10k, and Half-Marathon with chip timing, custom finisher medals, and wellness nutrition expo.')">
                                    <i class="bi bi-eye me-1"></i>Quick View
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Register Runner <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- No Results Placeholder for search/filter -->
            <div id="noEventsFound" class="text-center py-5 d-none">
                <i class="bi bi-search display-3 text-muted"></i>
                <h4 class="mt-3 fw-bold text-muted">No events match your search</h4>
                <p class="text-muted">Try adjusting your keyword or selecting a different category.</p>
                <button type="button" class="btn btn-outline-primary rounded-pill px-4" onclick="resetFilters()">
                    Reset All Filters
                </button>
            </div>
        </div>
    </section>

    <!-- Live Impact & Stats Section -->
    <section class="py-5 impact-stats-section position-relative" id="stats">
        <div class="container position-relative">
            <div class="row g-4 text-center">
                <div class="col-6 col-lg-3">
                    <div class="stat-glass-card p-4 rounded-4 shadow-sm">
                        <div class="stat-icon-wrapper mb-2 text-primary">
                            <i class="bi bi-people-fill fs-1"></i>
                        </div>
                        <h2 class="display-5 fw-extrabold text-dark counter-num" data-target="15000">15,000+</h2>
                        <p class="text-muted fw-semibold mb-0">Active Attendees</p>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-glass-card p-4 rounded-4 shadow-sm">
                        <div class="stat-icon-wrapper mb-2 text-success">
                            <i class="bi bi-calendar-check-fill fs-1"></i>
                        </div>
                        <h2 class="display-5 fw-extrabold text-dark counter-num" data-target="450">450+</h2>
                        <p class="text-muted fw-semibold mb-0">Successful Events</p>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-glass-card p-4 rounded-4 shadow-sm">
                        <div class="stat-icon-wrapper mb-2 text-warning">
                            <i class="bi bi-qr-code-scan fs-1"></i>
                        </div>
                        <h2 class="display-5 fw-extrabold text-dark counter-num" data-target="99">99.2%</h2>
                        <p class="text-muted fw-semibold mb-0">Instant Check-In Rate</p>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-glass-card p-4 rounded-4 shadow-sm">
                        <div class="stat-icon-wrapper mb-2 text-info">
                            <i class="bi bi-globe-americas fs-1"></i>
                        </div>
                        <h2 class="display-5 fw-extrabold text-dark counter-num" data-target="50">50+</h2>
                        <p class="text-muted fw-semibold mb-0">Cities Worldwide</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="py-5 bg-white" id="how-it-works">
        <div class="container py-4">
            <div class="text-center max-w-700 mx-auto mb-5">
                <span class="text-primary fw-bold text-uppercase tracking-wider small">Simple & Seamless</span>
                <h2 class="display-6 fw-bold mb-2">How EventSphere Works</h2>
                <p class="text-muted">From discovery to venue check-in in three effortless steps</p>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100 border-0 p-4 text-center feature-step-card shadow-sm rounded-4">
                        <div class="step-num-badge">1</div>
                        <div class="feature-icon-circle mx-auto my-3 bg-primary-subtle text-primary">
                            <i class="bi bi-compass fs-2"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Discover & Choose</h5>
                        <p class="text-muted small mb-0">
                            Explore hundreds of verified events filtered by your interests, dates, and budget.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 p-4 text-center feature-step-card shadow-sm rounded-4">
                        <div class="step-num-badge">2</div>
                        <div class="feature-icon-circle mx-auto my-3 bg-success-subtle text-success">
                            <i class="bi bi-ticket-perforated fs-2"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Instant Digital Booking</h5>
                        <p class="text-muted small mb-0">
                            Reserve tickets in seconds with secure processing, immediate confirmation, and zero hidden fees.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 p-4 text-center feature-step-card shadow-sm rounded-4">
                        <div class="step-num-badge">3</div>
                        <div class="feature-icon-circle mx-auto my-3 bg-warning-subtle text-warning">
                            <i class="bi bi-qr-code fs-2"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Scan & Attend</h5>
                        <p class="text-muted small mb-0">
                            Present your personalized QR pass directly from your phone. Fast, paperless gate entry.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Interactive FAQ Section -->
    <section class="py-5 bg-light" id="faq">
        <div class="container py-3">
            <div class="text-center max-w-700 mx-auto mb-5">
                <span class="text-primary fw-bold text-uppercase tracking-wider small">Got Questions?</span>
                <h2 class="display-6 fw-bold mb-2">Frequently Asked Questions</h2>
                <p class="text-muted">Everything you need to know about EventSphere</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="accordion custom-accordion shadow-sm rounded-4 overflow-hidden" id="faqAccordion">
                        <div class="accordion-item border-0">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                    <i class="bi bi-qr-code-scan text-primary me-2"></i> How do digital QR tickets work?
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted">
                                    Once your registration is complete, a unique cryptographic digital QR code is immediately generated and stored in your Attendee Portal. You can show it directly on your mobile screen at the entrance for instant scanning.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item border-0 border-top">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                    <i class="bi bi-award text-primary me-2"></i> Can I organize and sell tickets for my own events?
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted">
                                    Yes! Register for an <strong>Organizer</strong> account to build event landing pages, configure ticket tiers (VIP, Early Bird, General), monitor registrations live, and scan tickets with the built-in gate validator.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item border-0 border-top">
                            <h2 class="accordion-header" id="headingThree">
                                <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                    <i class="bi bi-shield-check text-primary me-2"></i> How does EventSphere protect against fraudulent tickets?
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted">
                                    Every issued pass possesses a tamper-proof verification hash and single-use digital certificate. When scanned at the gate, our system marks it as redeemed in real time, preventing duplicate admissions.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action Banner -->
    <section class="py-5 cta-banner-section text-white text-center position-relative overflow-hidden">
        <div class="container position-relative py-4">
            <h2 class="display-5 fw-extrabold mb-3">Ready to Experience the Next Event?</h2>
            <p class="lead mb-4 max-w-700 mx-auto opacity-90">
                Join thousands of attendees and event creators. Sign up in seconds and get instant access to all upcoming events.
            </p>
            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-lg px-4 fw-bold text-primary shadow">
                    <i class="bi bi-person-plus me-2"></i>Create Free Account
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg px-4 fw-semibold">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Sign In Now
                </a>
            </div>
        </div>
    </section>

    <!-- Interactive Event Quick View Modal -->
    <div class="modal fade" id="quickViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <span class="badge bg-primary rounded-pill px-3 py-2" id="modalCategory">Category</span>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <h4 class="fw-bold text-dark mb-2" id="modalTitle">Event Title</h4>
                    <div class="d-flex align-items-center text-muted small mb-3 gap-3">
                        <div><i class="bi bi-calendar3 text-primary me-1"></i><span id="modalDate">Date</span></div>
                        <div><i class="bi bi-geo-alt-fill text-danger me-1"></i><span id="modalVenue">Venue</span></div>
                    </div>
                    <p class="text-muted" id="modalDescription">Description details go here...</p>
                    <div class="bg-light p-3 rounded-3 mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <small class="text-muted d-block">Digital Pass</small>
                                <span class="fw-bold text-success fs-5">Instant QR Code Access</span>
                            </div>
                            <span class="badge bg-success-subtle text-success fw-bold px-3 py-2 rounded-pill">Verified</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary rounded-pill px-4 fw-bold">
                        Proceed to Book <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Modern Footer -->
    <footer class="landing-footer py-5 bg-dark text-white-50">
        <div class="container">
            <div class="row g-4 mb-4">
                <div class="col-lg-4">
                    <a class="navbar-brand d-flex align-items-center text-white mb-3 text-decoration-none" href="${pageContext.request.contextPath}/">
                        <span class="brand-icon-box me-2"><i class="bi bi-calendar2-event-fill"></i></span>
                        <span class="brand-text">Event<span class="text-primary">Sphere</span></span>
                    </a>
                    <p class="small text-muted mb-3">
                        The all-in-one platform for discovering experiences, booking digital tickets, and managing events seamlessly.
                    </p>
                    <div class="d-flex gap-2">
                        <a href="#" class="btn btn-sm btn-outline-secondary rounded-circle"><i class="bi bi-twitter-x"></i></a>
                        <a href="#" class="btn btn-sm btn-outline-secondary rounded-circle"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="btn btn-sm btn-outline-secondary rounded-circle"><i class="bi bi-linkedin"></i></a>
                        <a href="#" class="btn btn-sm btn-outline-secondary rounded-circle"><i class="bi bi-github"></i></a>
                    </div>
                </div>
                <div class="col-6 col-lg-2">
                    <h6 class="text-white fw-bold mb-3">Explore</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="#explore" class="text-muted text-decoration-none">Technology</a></li>
                        <li class="mb-2"><a href="#explore" class="text-muted text-decoration-none">Music & Live</a></li>
                        <li class="mb-2"><a href="#explore" class="text-muted text-decoration-none">Workshops</a></li>
                        <li class="mb-2"><a href="#explore" class="text-muted text-decoration-none">Conferences</a></li>
                    </ul>
                </div>
                <div class="col-6 col-lg-2">
                    <h6 class="text-white fw-bold mb-3">Platform</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/login" class="text-muted text-decoration-none">Organizer Login</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/register" class="text-muted text-decoration-none">Sign Up</a></li>
                        <li class="mb-2"><a href="#how-it-works" class="text-muted text-decoration-none">How It Works</a></li>
                        <li class="mb-2"><a href="#faq" class="text-muted text-decoration-none">Support & FAQ</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h6 class="text-white fw-bold mb-3">Stay Updated</h6>
                    <p class="small text-muted mb-3">Subscribe for announcements on exclusive early-bird passes and featured events.</p>
                    <form onsubmit="event.preventDefault(); handleNewsletter();" class="d-flex gap-2">
                        <input type="email" id="newsletterEmail" class="form-control form-control-sm bg-secondary bg-opacity-25 border-0 text-white" placeholder="Enter your email" required>
                        <button type="submit" class="btn btn-primary btn-sm px-3 fw-semibold">Subscribe</button>
                    </form>
                    <span id="newsletterMsg" class="d-block small text-success mt-2 d-none">✨ Subscribed successfully!</span>
                </div>
            </div>
            <div class="border-top border-secondary border-opacity-25 pt-4 text-center small text-muted">
                &copy; 2024 EventSphere. All rights reserved. Crafted for extraordinary experiences.
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle & Main Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Interactive Category Filter Logic
        let currentCategory = 'ALL';

        function selectCategoryPill(category, pillElement) {
            currentCategory = category;
            document.querySelectorAll('.category-pill-btn').forEach(btn => btn.classList.remove('active'));
            if (pillElement) pillElement.classList.add('active');
            
            const catSelect = document.getElementById('categoryFilter');
            if (catSelect) catSelect.value = category;

            filterCardsRealtime();
        }

        function quickFilter(category) {
            const btn = document.querySelector('.category-pill-btn[data-cat="' + category + '"]');
            selectCategoryPill(category, btn);
            const exploreSection = document.getElementById('explore');
            if (exploreSection) exploreSection.scrollIntoView({ behavior: 'smooth' });
        }

        function filterCardsRealtime() {
            const keyword = document.getElementById('searchKeyword').value.toLowerCase().trim();
            const cards = document.querySelectorAll('.event-item-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const title = (card.getAttribute('data-title') || '').toLowerCase();
                const category = (card.getAttribute('data-category') || '');
                const venue = (card.getAttribute('data-venue') || '').toLowerCase();

                const matchesCategory = (currentCategory === 'ALL' || category.toLowerCase() === currentCategory.toLowerCase());
                const matchesKeyword = (keyword === '' || title.includes(keyword) || venue.includes(keyword) || category.toLowerCase().includes(keyword));

                if (matchesCategory && matchesKeyword) {
                    card.style.display = '';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const countBadge = document.getElementById('eventsCountBadge');
            const noEvents = document.getElementById('noEventsFound');

            if (countBadge) {
                countBadge.innerText = 'Showing ' + visibleCount + ' ' + (currentCategory === 'ALL' ? 'Events' : currentCategory + ' Events');
            }

            if (noEvents) {
                if (visibleCount === 0) {
                    noEvents.classList.remove('d-none');
                } else {
                    noEvents.classList.add('d-none');
                }
            }
        }

        function resetFilters() {
            document.getElementById('searchKeyword').value = '';
            document.getElementById('categoryFilter').value = 'ALL';
            const allBtn = document.querySelector('.category-pill-btn[data-cat="ALL"]');
            selectCategoryPill('ALL', allBtn);
        }

        function performSearch() {
            const exploreSection = document.getElementById('explore');
            if (exploreSection) exploreSection.scrollIntoView({ behavior: 'smooth' });
        }

        // Quick View Modal
        function openQuickView(title, category, date, venue, desc) {
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalCategory').innerText = category;
            document.getElementById('modalDate').innerText = date;
            document.getElementById('modalVenue').innerText = venue;
            document.getElementById('modalDescription').innerText = desc;

            const modal = new bootstrap.Modal(document.getElementById('quickViewModal'));
            modal.show();
        }

        // Newsletter subscription feedback
        function handleNewsletter() {
            const email = document.getElementById('newsletterEmail');
            const msg = document.getElementById('newsletterMsg');
            if (email && email.value) {
                msg.classList.remove('d-none');
                email.value = '';
                setTimeout(() => msg.classList.add('d-none'), 4000);
            }
        }
    </script>
</body>
</html>
