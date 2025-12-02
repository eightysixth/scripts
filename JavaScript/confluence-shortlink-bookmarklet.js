/**
 * Confluence Shortlink Bookmarklet
 * 
 * This bookmarklet extracts the shortlink and page title from a Confluence page
 * and copies it to the clipboard as rich text (HTML format).
 * 
 * When pasted into rich text editors (Word, Outlook, Confluence, etc.),
 * it will appear as a clickable link with the page title as the link text.
 * 
 * Usage:
 * 1. Save this as a browser bookmark with the minified version 
 *      (.min.js file exists in this directory - generated directly on updates)
 * 2. Navigate to any Confluence page
 * 3. Click the bookmarklet
 * 4. Paste anywhere rich text is supported
 * 
 * Requirements:
 * - Page must have: <meta id="confluence-base-url">
 * - Page must have: <link rel="shortlink">
 * - Page must have: <meta name="ajs-page-title">
 * 
 */

javascript:(function() {
    try {
        // Check if this is a Confluence page
        const baseUrlMeta = document.getElementById('confluence-base-url');
        if (!baseUrlMeta) {
            alert('Not a Confluence page');
            return;
        }

        // Get the shortlink element
        const shortlink = document.querySelector('link[rel="shortlink"]');
        const pageTitleMeta = document.querySelector('meta[name="ajs-page-title"]');
        
        if (!shortlink || !pageTitleMeta) {
            alert('Required elements not found');
            return;
        }

        // Extract href and title
        const href = shortlink.getAttribute('href');
        const title = pageTitleMeta.getAttribute('content');

        // Create HTML content for rich text
        const htmlContent = `<a href="${href}">${title}</a>`;

        // Create clipboard items for both HTML and plain text
        const blob = new Blob([htmlContent], { type: 'text/html' });
        const textBlob = new Blob([`${title} (${href})`], { type: 'text/plain' });
        const item = new ClipboardItem({
            'text/html': blob,
            'text/plain': textBlob
        });

        // Copy to clipboard
        navigator.clipboard.write([item]).then(() => {
            // Show success message
            const msg = document.createElement('div');
            msg.textContent = '✓ Rich text link copied to clipboard!';
            msg.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);background:#36b37e;color:#fff;padding:20px 30px;border-radius:8px;z-index:10000;font-size:16px;font-family:sans-serif;box-shadow:0 4px 12px rgba(0,0,0,0.3);';
            document.body.appendChild(msg);
            
            setTimeout(() => msg.remove(), 2000);
        }).catch(err => {
            alert('Copy failed: ' + err.message);
        });

    } catch (e) {
        alert('Error: ' + e.message);
    }
})();
