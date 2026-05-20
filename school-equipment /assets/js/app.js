/**
 * app.js — Request form logic (index.php)
 */

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('borrowForm');
  if (!form) return;

  const successAlert = document.getElementById('formSuccess');

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    if (!validateForm(form)) return;

    const data = {
      name:                form.fullName.value,
      role:                form.role.value,
      item:                form.item.value,
      quantity:            form.quantity.value,
      reason:              form.reason.value,
      requestedReturnDate: form.requestedReturnDate.value,
    };

    Storage.add(data);
    form.reset();
    showAlert(successAlert);
    showToast('Request submitted successfully!', 'success');
  });
});

function validateForm(form) {
  let valid = true;
  const fields = ['fullName', 'role', 'item', 'quantity', 'reason', 'requestedReturnDate'];

  fields.forEach(name => {
    const el = form[name];
    const group = el?.closest('.form-group');
    const err = group?.querySelector('.field-error');

    if (err) err.remove();

    if (!el || !el.value.trim()) {
      valid = false;
      if (group) {
        const msg = document.createElement('span');
        msg.className = 'field-error';
        msg.style.cssText = 'color:#dc2626;font-size:0.78rem;margin-top:2px;';
        msg.textContent = 'This field is required.';
        group.appendChild(msg);
        el.style.borderColor = '#dc2626';
        el.addEventListener('input', () => {
          el.style.borderColor = '';
          msg.remove();
        }, { once: true });
      }
    }
  });

  const qty = form.quantity;
  if (qty && (isNaN(qty.value) || parseInt(qty.value) < 1)) {
    valid = false;
    const group = qty.closest('.form-group');
    if (group && !group.querySelector('.field-error')) {
      const msg = document.createElement('span');
      msg.className = 'field-error';
      msg.style.cssText = 'color:#dc2626;font-size:0.78rem;margin-top:2px;';
      msg.textContent = 'Enter a valid quantity (minimum 1).';
      group.appendChild(msg);
      qty.style.borderColor = '#dc2626';
    }
  }

  const dateField = form.requestedReturnDate;
  if (dateField && dateField.value) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const chosen = new Date(dateField.value);
    if (chosen < today) {
      valid = false;
      const group = dateField.closest('.form-group');
      if (group && !group.querySelector('.field-error')) {
        const msg = document.createElement('span');
        msg.className = 'field-error';
        msg.style.cssText = 'color:#dc2626;font-size:0.78rem;margin-top:2px;';
        msg.textContent = 'Return date must be today or in the future.';
        group.appendChild(msg);
        dateField.style.borderColor = '#dc2626';
      }
    }
  }

  return valid;
}

function showAlert(el) {
  if (!el) return;
  el.classList.remove('hidden');
  el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  setTimeout(() => el.classList.add('hidden'), 5000);
}
