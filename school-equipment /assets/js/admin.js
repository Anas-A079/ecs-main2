/**
 * admin.js — Admin dashboard logic (admin.php)
 */

document.addEventListener('DOMContentLoaded', () => {
  let currentFilter = 'All';
  let currentSearch = '';
  let pendingDeleteId = null;
  let pendingApproveId = null;

  const tbody       = document.getElementById('requestsTbody');
  const emptyState  = document.getElementById('emptyState');
  const searchInput = document.getElementById('searchInput');
  const filterBtns  = document.querySelectorAll('.filter-btn');

  // Stats
  const statTotal    = document.getElementById('statTotal');
  const statPending  = document.getElementById('statPending');
  const statApproved = document.getElementById('statApproved');
  const statDenied   = document.getElementById('statDenied');

  // Modals
  const deleteModal        = document.getElementById('deleteModal');
  const approveModal       = document.getElementById('approveModal');
  const approvedDateInput  = document.getElementById('approvedReturnDate');

  // ── Render ─────────────────────────────────────────────

  function render() {
    updateStats();
    const rows = Storage.filter({ status: currentFilter, search: currentSearch });

    if (rows.length === 0) {
      tbody.innerHTML = '';
      emptyState.classList.remove('hidden');
      return;
    }

    emptyState.classList.add('hidden');
    tbody.innerHTML = rows.map(rowHTML).join('');
  }

  function updateStats() {
    const c = Storage.getCounts();
    statTotal.textContent    = c.total;
    statPending.textContent  = c.pending;
    statApproved.textContent = c.approved;
    statDenied.textContent   = c.denied;
  }

  function rowHTML(r) {
    const badgeClass = r.status === 'Approved' ? 'badge-approved'
                     : r.status === 'Denied'   ? 'badge-denied'
                     :                           'badge-pending';

    const approvedDate = r.approvedReturnDate
      ? formatDate(r.approvedReturnDate)
      : '<span style="color:var(--gray-400)">—</span>';

    const approveBtn = r.status === 'Pending'
      ? `<button class="btn btn-sm btn-success" onclick="openApprove('${r.id}')">Approve</button>`
      : '';

    const denyBtn = r.status === 'Pending'
      ? `<button class="btn btn-sm btn-outline" onclick="denyRequest('${r.id}')">Deny</button>`
      : '';

    return `
      <tr>
        <td>
          <div style="font-weight:600;color:var(--gray-800)">${esc(r.name)}</div>
          <div style="font-size:0.78rem;color:var(--gray-400)">${formatDate(r.createdAt)}</div>
        </td>
        <td>${esc(r.role)}</td>
        <td>${esc(r.item)}</td>
        <td>${r.quantity}</td>
        <td style="max-width:160px;white-space:normal">${esc(r.reason)}</td>
        <td>${formatDate(r.requestedReturnDate)}</td>
        <td><span class="badge ${badgeClass}">${r.status}</span></td>
        <td>${approvedDate}</td>
        <td>
          <div class="actions-cell">
            ${approveBtn}
            ${denyBtn}
            <button class="btn btn-sm btn-danger" onclick="openDelete('${r.id}')">Delete</button>
          </div>
        </td>
      </tr>`;
  }

  // ── Filters & Search ───────────────────────────────────

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentFilter = btn.dataset.filter;
      render();
    });
  });

  if (searchInput) {
    searchInput.addEventListener('input', debounce(() => {
      currentSearch = searchInput.value;
      render();
    }, 200));
  }

  // ── Delete ─────────────────────────────────────────────

  window.openDelete = (id) => {
    pendingDeleteId = id;
    deleteModal.classList.remove('hidden');
  };

  document.getElementById('confirmDelete')?.addEventListener('click', () => {
    if (!pendingDeleteId) return;
    Storage.remove(pendingDeleteId);
    pendingDeleteId = null;
    deleteModal.classList.add('hidden');
    showToast('Request deleted.', 'error');
    render();
  });

  document.getElementById('cancelDelete')?.addEventListener('click', () => {
    pendingDeleteId = null;
    deleteModal.classList.add('hidden');
  });

  // ── Approve ────────────────────────────────────────────

  window.openApprove = (id) => {
    pendingApproveId = id;
    const req = Storage.getById(id);
    if (req && req.requestedReturnDate) {
      approvedDateInput.value = req.requestedReturnDate;
    } else {
      approvedDateInput.value = '';
    }
    approveModal.classList.remove('hidden');
  };

  document.getElementById('confirmApprove')?.addEventListener('click', () => {
    if (!pendingApproveId) return;
    const date = approvedDateInput.value;
    if (!date) {
      approvedDateInput.style.borderColor = '#dc2626';
      approvedDateInput.focus();
      return;
    }
    Storage.approve(pendingApproveId, date);
    pendingApproveId = null;
    approveModal.classList.add('hidden');
    showToast('Request approved!', 'success');
    render();
  });

  document.getElementById('cancelApprove')?.addEventListener('click', () => {
    pendingApproveId = null;
    approveModal.classList.add('hidden');
  });

  // ── Deny ───────────────────────────────────────────────

  window.denyRequest = (id) => {
    Storage.deny(id);
    showToast('Request denied.', 'warning');
    render();
  };

  // ── Modal overlay close ────────────────────────────────

  [deleteModal, approveModal].forEach(modal => {
    modal?.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.add('hidden');
        pendingDeleteId = null;
        pendingApproveId = null;
      }
    });
  });

  // ── Close modal buttons ────────────────────────────────

  document.querySelectorAll('.modal-close').forEach(btn => {
    btn.addEventListener('click', () => {
      btn.closest('.modal-overlay')?.classList.add('hidden');
      pendingDeleteId = null;
      pendingApproveId = null;
    });
  });

  // ── Initial render ─────────────────────────────────────

  render();
});

// ── Utilities ───────────────────────────────────────────

function formatDate(dateStr) {
  if (!dateStr) return '—';
  try {
    // Handle ISO strings and YYYY-MM-DD
    const d = new Date(dateStr.length > 10 ? dateStr : dateStr + 'T00:00:00');
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  } catch {
    return dateStr;
  }
}

function esc(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function debounce(fn, delay) {
  let t;
  return (...args) => {
    clearTimeout(t);
    t = setTimeout(() => fn(...args), delay);
  };
}
