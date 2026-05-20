<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard — School Equipment System</title>
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
      <a href="index.php" class="nav-link">Borrow Request</a>
      <a href="admin.php" class="nav-link active">Admin Dashboard</a>
    </nav>
  </div>
</header>

<!-- ── Main ── -->
<main class="page-wrapper">

  <h1 class="page-title">
    Admin Dashboard
    <p class="page-subtitle">Review, approve, or deny equipment borrowing requests.</p>
  </h1>

  <!-- ── Summary cards ── -->
  <div class="stats-grid">
    <div class="stat-card total">
      <div class="stat-icon">
        <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round"
            d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        </svg>
      </div>
      <span class="stat-label">Total Requests</span>
      <span class="stat-value" id="statTotal">0</span>
    </div>

    <div class="stat-card pending">
      <div class="stat-icon">
        <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round"
            d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
      </div>
      <span class="stat-label">Pending</span>
      <span class="stat-value" id="statPending">0</span>
    </div>

    <div class="stat-card approved">
      <div class="stat-icon">
        <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
        </svg>
      </div>
      <span class="stat-label">Approved</span>
      <span class="stat-value" id="statApproved">0</span>
    </div>

    <div class="stat-card denied">
      <div class="stat-icon">
        <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
        </svg>
      </div>
      <span class="stat-label">Denied</span>
      <span class="stat-value" id="statDenied">0</span>
    </div>
  </div>

  <!-- ── Requests table card ── -->
  <div class="card">
    <div class="card-header">
      <span class="card-title">All Requests</span>
      <a href="index.php" class="btn btn-primary btn-sm">
        <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/>
        </svg>
        New Request
      </a>
    </div>

    <!-- Toolbar -->
    <div style="padding:16px 24px;border-bottom:1px solid var(--gray-200);">
      <div class="toolbar">
        <div class="search-wrap">
          <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round"
              d="M21 21l-4.35-4.35M17 11A6 6 0 115 11a6 6 0 0112 0z"/>
          </svg>
          <input
            type="text"
            id="searchInput"
            class="form-control search-input"
            placeholder="Search by name or item…"
          />
        </div>
        <div class="filter-group">
          <button class="filter-btn active" data-filter="All">All</button>
          <button class="filter-btn" data-filter="Pending">Pending</button>
          <button class="filter-btn" data-filter="Approved">Approved</button>
          <button class="filter-btn" data-filter="Denied">Denied</button>
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Role</th>
            <th>Item</th>
            <th>Qty</th>
            <th>Reason</th>
            <th>Req. Return</th>
            <th>Status</th>
            <th>Appr. Return</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody id="requestsTbody"></tbody>
      </table>

      <!-- Empty state -->
      <div id="emptyState" class="empty-state hidden">
        <svg width="48" height="48" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
          <path stroke-linecap="round" stroke-linejoin="round"
            d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        </svg>
        <p>No requests found.</p>
      </div>
    </div>

  </div><!-- /.card -->

</main>

<!-- ── Delete Confirmation Modal ── -->
<div id="deleteModal" class="modal-overlay hidden" role="dialog" aria-modal="true" aria-labelledby="deleteModalTitle">
  <div class="modal">
    <div class="modal-header">
      <span class="modal-title" id="deleteModalTitle">Delete Request</span>
      <button class="modal-close" aria-label="Close">&times;</button>
    </div>
    <div class="modal-body">
      <p style="color:var(--gray-600);font-size:0.95rem;">
        Are you sure you want to delete this request? This action <strong>cannot be undone</strong>.
      </p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline" id="cancelDelete">Cancel</button>
      <button class="btn btn-danger" id="confirmDelete">Yes, Delete</button>
    </div>
  </div>
</div>

<!-- ── Approve Modal ── -->
<div id="approveModal" class="modal-overlay hidden" role="dialog" aria-modal="true" aria-labelledby="approveModalTitle">
  <div class="modal">
    <div class="modal-header">
      <span class="modal-title" id="approveModalTitle">Approve Request</span>
      <button class="modal-close" aria-label="Close">&times;</button>
    </div>
    <div class="modal-body">
      <p style="color:var(--gray-600);font-size:0.95rem;margin-bottom:20px;">
        Set the official return date for this request before approving.
      </p>
      <div class="form-group">
        <label class="form-label" for="approvedReturnDate">
          Approved Return Date <span class="required" style="color:var(--danger)">*</span>
        </label>
        <input
          type="date"
          id="approvedReturnDate"
          class="form-control"
        />
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline" id="cancelApprove">Cancel</button>
      <button class="btn btn-success" id="confirmApprove">
        <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
          <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
        </svg>
        Approve Request
      </button>
    </div>
  </div>
</div>

<!-- ── Toast container ── -->
<div class="toast-container" id="toastContainer"></div>

<script src="assets/js/storage.js"></script>
<script src="assets/js/admin.js"></script>
<script>
/**
 * Shared toast utility
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

// Set today as min date for approve modal
document.addEventListener('DOMContentLoaded', () => {
  const today = new Date().toISOString().split('T')[0];
  const approvedInput = document.getElementById('approvedReturnDate');
  if (approvedInput) approvedInput.min = today;
});
</script>
<style>
  .hidden { display: none !important; }
</style>

</body>
</html>
