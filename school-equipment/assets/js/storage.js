/**
 * storage.js — localStorage helpers for the borrowing system
 */

const STORAGE_KEY = 'schoolBorrowingRequests';

const Storage = {
  /**
   * Return all requests (newest first)
   */
  getAll() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      const data = raw ? JSON.parse(raw) : [];
      return Array.isArray(data) ? data : [];
    } catch {
      return [];
    }
  },

  /**
   * Persist the full array
   */
  _save(requests) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(requests));
  },

  /**
   * Add a new request; returns the saved object
   */
  add(data) {
    const requests = this.getAll();
    const request = {
      id: 'req_' + Date.now() + '_' + Math.random().toString(36).slice(2, 7),
      name: data.name.trim(),
      role: data.role,
      item: data.item,
      quantity: parseInt(data.quantity, 10) || 1,
      reason: data.reason.trim(),
      requestedReturnDate: data.requestedReturnDate,
      approvedReturnDate: '',
      status: 'Pending',
      createdAt: new Date().toISOString(),
    };
    requests.unshift(request);
    this._save(requests);
    return request;
  },

  /**
   * Find one by id
   */
  getById(id) {
    return this.getAll().find(r => r.id === id) || null;
  },

  /**
   * Update fields on an existing request
   */
  update(id, fields) {
    const requests = this.getAll();
    const idx = requests.findIndex(r => r.id === id);
    if (idx === -1) return false;
    requests[idx] = { ...requests[idx], ...fields };
    this._save(requests);
    return requests[idx];
  },

  /**
   * Delete a request by id
   */
  remove(id) {
    const requests = this.getAll().filter(r => r.id !== id);
    this._save(requests);
  },

  /**
   * Approve a request with an approved return date
   */
  approve(id, approvedReturnDate) {
    return this.update(id, {
      status: 'Approved',
      approvedReturnDate: approvedReturnDate || '',
    });
  },

  /**
   * Deny a request
   */
  deny(id) {
    return this.update(id, {
      status: 'Denied',
      approvedReturnDate: '',
    });
  },

  /**
   * Summary counts
   */
  getCounts() {
    const all = this.getAll();
    return {
      total:    all.length,
      pending:  all.filter(r => r.status === 'Pending').length,
      approved: all.filter(r => r.status === 'Approved').length,
      denied:   all.filter(r => r.status === 'Denied').length,
    };
  },

  /**
   * Filter & search helper
   */
  filter({ status = 'All', search = '' }) {
    let list = this.getAll();
    if (status && status !== 'All') {
      list = list.filter(r => r.status === status);
    }
    if (search && search.trim()) {
      const q = search.trim().toLowerCase();
      list = list.filter(r =>
        r.name.toLowerCase().includes(q) ||
        r.item.toLowerCase().includes(q)
      );
    }
    return list;
  },
};
