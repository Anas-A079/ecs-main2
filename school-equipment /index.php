<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Borrow Request — School Equipment System</title>
  <link rel="stylesheet" href="assets/css/style.css" />
</head>
<body>

<!-- ── Header ── -->
<header class="site-header">
  <div class="header-inner">
    <a href="index.php" class="header-brand">
      <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round"
          d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
      </svg>
      School Equipment
    </a>
    <nav class="header-nav">
      <a href="index.php" class="nav-link active">Borrow Request</a>
      <a href="admin.php" class="nav-link">Admin Dashboard</a>
    </nav>
  </div>
</header>

<!-- ── Main ── -->
<main class="page-wrapper">

  <div style="max-width:680px;margin:0 auto;">
    <h1 class="page-title">
      Equipment Borrowing Request
      <p class="page-subtitle">Fill in the form below to request to borrow school equipment.</p>
    </h1>

    <!-- Success alert -->
    <div id="formSuccess" class="alert alert-success hidden" role="alert">
      <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" style="flex-shrink:0">
        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
      </svg>
      <span>Your request has been submitted successfully! You can check its status on the <a href="admin.php" style="color:inherit;font-weight:700;">Admin Dashboard</a>.</span>
    </div>

    <div class="card">
      <div class="card-header">
        <span class="card-title">New Borrowing Request</span>
        <span style="font-size:0.8rem;color:var(--gray-400);">Fields marked <span style="color:var(--danger)">*</span> are required</span>
      </div>
      <div class="card-body">
        <form id="borrowForm" novalidate>

          <div class="form-grid">

            <!-- Full Name -->
            <div class="form-group">
              <label class="form-label" for="fullName">
                Full Name <span class="required">*</span>
              </label>
              <input
                type="text"
                id="fullName"
                name="fullName"
                class="form-control"
                placeholder="e.g. Maria Santos"
                autocomplete="name"
              />
            </div>

            <!-- Role -->
            <div class="form-group">
              <label class="form-label" for="role">
                Role <span class="required">*</span>
              </label>
              <select id="role" name="role" class="form-control">
                <option value="">— Select role —</option>
                <option value="Student">Student</option>
                <option value="Teacher">Teacher</option>
              </select>
            </div>

            <!-- Item -->
            <div class="form-group">
              <label class="form-label" for="item">
                Item to Borrow <span class="required">*</span>
              </label>
              <select id="item" name="item" class="form-control">
                <option value="">— Select item —</option>
                <option value="Laptop">Laptop</option>
                <option value="Projector">Projector</option>
                <option value="Calculator">Calculator</option>
                <option value="Camera">Camera</option>
                <option value="Microphone">Microphone</option>
                <option value="Tablet">Tablet</option>
                <option value="HDMI Cable">HDMI Cable</option>
              </select>
            </div>

            <!-- Quantity -->
            <div class="form-group">
              <label class="form-label" for="quantity">
                Quantity <span class="required">*</span>
              </label>
              <input
                type="number"
                id="quantity"
                name="quantity"
                class="form-control"
                placeholder="1"
                min="1"
                max="50"
                value="1"
              />
            </div>

            <!-- Requested Return Date -->
            <div class="form-group">
              <label class="form-label" for="requestedReturnDate">
                Requested Return Date <span class="required">*</span>
              </label>
              <input
                type="date"
                id="requestedReturnDate"
                name="requestedReturnDate"
                class="form-control"
              />
              <span class="form-hint">The date you plan to return the item.</span>
            </div>

            <!-- Reason -->
            <div class="form-group span-2">
              <label class="form-label" for="reason">
                Reason for Borrowing <span class="required">*</span>
              </label>
              <textarea
                id="reason"
                name="reason"
                class="form-control"
                placeholder="Briefly explain why you need this item…"
                rows="3"
              ></textarea>
            </div>

          </div><!-- /.form-grid -->

          <hr class="divider" />

          <div style="display:flex;gap:12px;justify-content:flex-end;flex-wrap:wrap;">
            <button type="reset" class="btn btn-outline">Clear Form</button>
            <button type="submit" class="btn btn-primary">
              <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/>
              </svg>
              Submit Request
            </button>
          </div>

        </form>
      </div><!-- /.card-body -->
    </div><!-- /.card -->

    <!-- Info note -->
    <div class="alert alert-info" style="margin-top:20px;">
      <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" style="flex-shrink:0">
        <path stroke-linecap="round" stroke-linejoin="round"
          d="M13 16h-1v-4h-1m1-4h.01M12 2a10 10 0 110 20A10 10 0 0112 2z"/>
      </svg>
      <span>
        Requests are reviewed by an administrator. Check the
        <a href="admin.php" style="color:inherit;font-weight:700;">Admin Dashboard</a>
        to view your request status.
      </span>
    </div>

  </div><!-- /max-width wrapper -->

</main>

<!-- ── Toast container ── -->
<div class="toast-container" id="toastContainer"></div>

<script src="assets/js/storage.js"></script>
<script src="assets/js/app.js"></script>
<script>
  // Set today as min date for return date
  document.addEventListener('DOMContentLoaded', () => {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('requestedReturnDate').min = today;
  });
</script>
<script>
/**
 * Shared toast utility (used by both pages)
 */
function showToast(message, type = 'default') {
  const container = document.getElementById('toastContainer');
  if (!container) return;

  const toast = document.createElement('div');
  toast.className = 'toast' + (type !== 'default' ? ' toast-' + type : '');

  const icon = type === 'success' ? '✓'
             : type === 'error'   ? '✕'
             : type === 'warning' ? '!'
             : 'ℹ';

  toast.innerHTML = `<span style="font-weight:700">${icon}</span><span>${message}</span>`;
  container.appendChild(toast);

  setTimeout(() => {
    toast.classList.add('toast-hide');
    toast.addEventListener('animationend', () => toast.remove());
  }, 3200);
}

// Hidden class helper
document.querySelectorAll('.hidden').forEach(el => {
  el.style.display = 'none';
});

// Override hidden toggle
const origShow = HTMLElement.prototype.classList;
</script>
<style>
  .hidden { display: none !important; }
</style>

</body>
</html>
