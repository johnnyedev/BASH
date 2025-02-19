// ==UserScript==
// @name         Confluence: Wide-View Inline Comments
// @namespace    https://github.com/johnnyedev
// @version      v1.2
// @description  Wide-View Format for Inline Comment Panel
// @author       https://github.com/johnnyedev
// @match        https://*.atlassian.net/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=atlassian.net
// @grant        GM_addStyle
// @run-at       document-start
// ==/UserScript==

GM_addStyle ( `
#inline-comment-sidebar {
    width: 85% !important;
}
` );
