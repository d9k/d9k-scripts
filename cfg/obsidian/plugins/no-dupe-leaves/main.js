/*
THIS IS A GENERATED/BUNDLED FILE BY ESBUILD
if you want to view the source, please visit the github repository of this plugin
*/

var w=Object.create;var p=Object.defineProperty;var h=Object.getOwnPropertyDescriptor;var y=Object.getOwnPropertyNames;var v=Object.getPrototypeOf,O=Object.prototype.hasOwnProperty;var d=e=>p(e,"__esModule",{value:!0});var P=(e,n)=>{d(e);for(var r in n)p(e,r,{get:n[r],enumerable:!0})},k=(e,n,r)=>{if(n&&typeof n=="object"||typeof n=="function")for(let t of y(n))!O.call(e,t)&&t!=="default"&&p(e,t,{get:()=>n[t],enumerable:!(r=h(n,t))||r.enumerable});return e},b=e=>k(d(p(e!=null?w(v(e)):{},"default",e&&e.__esModule&&"default"in e?{get:()=>e.default,enumerable:!0}:{value:e,enumerable:!0})),e);P(exports,{default:()=>f});var c=b(require("obsidian"));function g(e,n){let r=Object.keys(n).map(t=>C(e,t,n[t]));return r.length===1?r[0]:function(){r.forEach(t=>t())}}function C(e,n,r){let t=e[n],o=e.hasOwnProperty(n),i=r(t);return t&&Object.setPrototypeOf(i,t),Object.setPrototypeOf(s,i),e[n]=s,a;function s(...u){return i===t&&e[n]===s&&a(),i.apply(this,u)}function a(){e[n]===s&&(o?e[n]=t:delete e[n]),i!==t&&(i=t,Object.setPrototypeOf(s,t||Function))}}var m,f=class extends c.Plugin{async onload(){m=g(c.Workspace.prototype,{openLinkText(n){return function(r,t,o,i){if(o)return n&&n.apply(this,[r,t,o,i]);let s=$(r),a=!1;return app.workspace.iterateAllLeaves(u=>{let l=u.getViewState();l.type==="markdown"&&l.state?.file===s.name&&(app.workspace.setActiveLeaf(u,{focus:!0}),a=!0)}),a||(a=n&&n.apply(this,[r,t,o,i])),V(s),a}}})}onunload(){m()}};function V(e){let n=app.metadataCache.getCache(e.name),r=app.workspace.getActiveViewOfType(c.MarkdownView);if(e.heading){let t=n.headings.find(o=>o.heading===e.heading);t&&r.editor.setCursor(t.position.start.line)}else if(e.block){let t=n.blocks[e.block];t&&r.editor.setCursor(t.position.start.line)}}function $(e){let n=e.match(/\^(.*)$/),r=n?n[1]:void 0;e=e.replace(/(\^.*)$/,"");let t=e.match(/#(.*)$/),o=t?t[1]:void 0;return e=e.replace(/(#.*)$/,""),{name:e+(e.endsWith(".md")?"":".md"),heading:o,block:r}}