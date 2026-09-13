/**
 * Global SweetAlert2 Dialog System for HATS.VN
 * Replaces crude browser confirm() / alert() with sleek, modern UI modals.
 */

window.confirmAction = function(options) {
    const config = {
        title: options.title || 'Xác nhận thao tác',
        text: options.text || 'Bạn có chắc chắn muốn thực hiện hành động này?',
        icon: options.icon || 'warning',
        showCancelButton: true,
        confirmButtonColor: options.confirmColor || '#d33',
        cancelButtonColor: options.cancelColor || '#6c757d',
        confirmButtonText: options.confirmText || 'Đồng ý',
        cancelButtonText: options.cancelText || 'Hủy bỏ',
        reverseButtons: true,
        focusCancel: true
    };

    return Swal.fire(config);
};

document.addEventListener('DOMContentLoaded', function() {
    // Intercept clicks on links or buttons with data-confirm
    document.addEventListener('click', function(e) {
        const trigger = e.target.closest('[data-confirm]');
        if (!trigger) return;

        // If the matched element is a FORM, let the submit event handler handle it
        if (trigger.tagName === 'FORM') {
            return;
        }

        e.preventDefault();
        e.stopPropagation();

        const message = trigger.getAttribute('data-confirm');
        const title = trigger.getAttribute('data-confirm-title') || 'Xác nhận';
        const icon = trigger.getAttribute('data-confirm-icon') || 'warning';
        const confirmText = trigger.getAttribute('data-confirm-btn') || 'Đồng ý';
        const confirmColor = trigger.getAttribute('data-confirm-color') || '#d33';

        Swal.fire({
            title: title,
            text: message,
            icon: icon,
            showCancelButton: true,
            confirmButtonColor: confirmColor,
            cancelButtonColor: '#6c757d',
            confirmButtonText: confirmText,
            cancelButtonText: 'Hủy bỏ',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                if (trigger.tagName === 'A' && trigger.href) {
                    window.location.href = trigger.href;
                } else if (trigger.tagName === 'BUTTON') {
                    const form = trigger.form || trigger.closest('form');
                    if (form) {
                        form.dataset.confirmed = 'true';
                        form.submit();
                    }
                }
            }
        });
    }, true);

    // Intercept form submissions with data-confirm
    document.addEventListener('submit', function(e) {
        const form = e.target.closest('form[data-confirm]');
        if (!form || form.dataset.confirmed === 'true') return;

        e.preventDefault();
        e.stopPropagation();

        const message = form.getAttribute('data-confirm');
        const title = form.getAttribute('data-confirm-title') || 'Xác nhận thao tác';
        const icon = form.getAttribute('data-confirm-icon') || 'warning';
        const confirmText = form.getAttribute('data-confirm-btn') || 'Xác nhận';
        const confirmColor = form.getAttribute('data-confirm-color') || '#0d6efd';

        Swal.fire({
            title: title,
            text: message,
            icon: icon,
            showCancelButton: true,
            confirmButtonColor: confirmColor,
            cancelButtonColor: '#6c757d',
            confirmButtonText: confirmText,
            cancelButtonText: 'Hủy bỏ',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                form.dataset.confirmed = 'true';
                form.submit();
            }
        });
    }, true);
});
