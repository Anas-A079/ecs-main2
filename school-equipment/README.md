# School Equipment Borrowing System

A simple, frontend-focused web application that allows students and teachers to request to borrow school equipment. An administrator can review, approve, or deny requests and set official return dates. All data is stored in the browser using **localStorage** — no database or backend logic required.

---

## Features

- **Borrowing request form** — submit requests with name, role, item, quantity, reason, and requested return date
- **Admin dashboard** — view all requests in a sortable, searchable table
- **Summary cards** — live counts of Total, Pending, Approved, and Denied requests
- **Approve / Deny / Delete** — with confirmation dialogs and return date picker
- **Search & filter** — search by name or item; filter by status
- **Responsive design** — works on mobile and desktop
- **No login required** — open access for demonstration purposes

---

## Technology Stack

| Layer        | Technology                      |
|---|---|
| Server       | PHP (page serving only)         |
| Markup       | HTML5                           |
| Styling      | CSS3 (custom, no frameworks)    |
| Behaviour    | Vanilla JavaScript (ES6+)       |
| Persistence  | Browser `localStorage`          |

---

## File Structure

```
school-equipment/
├── index.php              # Borrowing request form
├── admin.php              # Admin dashboard
├── assets/
│   ├── css/
│   │   └── style.css      # All styles
│   └── js/
│       ├── storage.js     # localStorage read/write helpers
│       ├── app.js         # Request form logic
│       └── admin.js       # Dashboard logic (table, modals, filters)
└── README.md
```

---

## Requirements

- **PHP 7.4 or later** (PHP 8.x recommended)
- A web server that can serve PHP files (Apache, Nginx, or PHP's built-in server)

> The application has **no database**, **no Composer dependencies**, and **no build step**.

---

## Setup & Running

### Option 1 — PHP built-in server (quickest)

```bash
# From the project root (school-equipment/)
php -S localhost:8000
```

Then open **http://localhost:8000** in your browser.

### Option 2 — Apache (XAMPP / WAMP / LAMP)

1. Copy the `school-equipment/` folder into your web root (e.g. `htdocs/` or `www/`).
2. Start Apache.
3. Open **http://localhost/school-equipment/**.

### Option 3 — Nginx

Point the Nginx root at the `school-equipment/` directory and enable PHP-FPM processing for `.php` files. A minimal server block:

```nginx
server {
    listen 80;
    root /var/www/school-equipment;
    index index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

## Usage

### Submitting a Request (`index.php`)

1. Open the home page.
2. Fill in all required fields:
   - Full name
   - Role (Student or Teacher)
   - Item to borrow (from the dropdown)
   - Quantity
   - Reason for borrowing
   - Requested return date
3. Click **Submit Request**.
4. A success message confirms the request has been saved.

### Managing Requests (`admin.php`)

1. Open the Admin Dashboard.
2. View all requests in the table. Summary cards at the top show counts.
3. **Search** — type in the search box to filter by name or item.
4. **Filter** — click All / Pending / Approved / Denied to narrow the view.
5. **Approve** — click the Approve button, set the official return date, then confirm.
6. **Deny** — click the Deny button to mark a request as denied.
7. **Delete** — click Delete and confirm the dialog to permanently remove a request.

---

## Data Model

Each request stored in `localStorage` has the following shape:

```json
{
  "id": "req_1716300000000_abc12",
  "name": "Maria Santos",
  "role": "Student",
  "item": "Laptop",
  "quantity": 1,
  "reason": "For my thesis presentation.",
  "requestedReturnDate": "2026-05-30",
  "approvedReturnDate": "2026-05-28",
  "status": "Approved",
  "createdAt": "2026-05-20T09:00:00.000Z"
}
```

All requests are stored as a JSON array under the key **`schoolBorrowingRequests`** in `localStorage`.

---

## Browser Compatibility

Works in all modern browsers (Chrome, Firefox, Edge, Safari). Requires JavaScript enabled and `localStorage` available.

---

## Notes

- Data is stored **per browser / per origin**. Clearing browser data will erase all requests.
- There is no authentication — the admin dashboard is open to anyone with the URL.
- To reset all data, open your browser's developer tools → Application → Local Storage → delete the `schoolBorrowingRequests` key.
