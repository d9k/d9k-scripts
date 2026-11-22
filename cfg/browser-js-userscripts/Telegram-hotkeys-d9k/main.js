// ==UserScript==
//
// @name         Telegram hotkeys d9k
// @namespace    http://tampermonkey.net/
// @version      2026-11-22
// @description  try to take over the world!
// @author       You
// @match        *://web.telegram.org/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=telegram.org
// @run-at       document-start
// @grant        none
// ==/UserScript==

/** ========================== */
/** === USER SCRIPT BEGINS === */
/** ========================== */
/** Bootstrap from light-cmd-palette/examples/index-iife.html */

(function() {
    /** hotkeys-js v3.13.7 required! */
    /** light-cmd-palette-userscripts 0.1.5 required! (https://github.com/d9k/light-cmd-palette-userscripts/blob/main/dist/commandPalette.iife.js) */

    var logPrefix = 'Telegram hotkeys d9k userscript:';

    var commandPaletteCss = '/** (Declared further below) */';

    // Timeout to wait for deps to load
    setTimeout(() => {
      'use strict';

      const injectStyle = (css) => {
          const style = document.createElement('style');
          style.textContent = css;
          document.head.appendChild(style);
      };

      injectStyle(commandPaletteCss);

      function sleepMs(ms) {
          return new Promise(resolve => setTimeout(resolve, ms));
      }

      function elementMouseRightClick(element) {
          var rect = element.getBoundingClientRect();
          var rightClickEvents = ['pointerdown', 'mousedown', 'contextmenu', 'mouseup'];
          for (var eventName of rightClickEvents) {
              element.dispatchEvent(new MouseEvent(eventName, {
                  bubbles: true, cancelable: true, view: window, button: 2,
                  clientX: rect.left + rect.width / 2, clientY: rect.top + rect.height / 2
              }));
          }
      }

      async function waitForMessageContextMenu() {
          // Unpredictable appearance: poll for a few seconds
          for (var i = 0; i < 20; i++) {
              var contextMenu = document.getElementById('bubble-contextmenu');
              if (contextMenu) {
                  return contextMenu;
              }
              await sleepMs(100);
          }

          throw new Error('No message context menu!');
      }

      function contextMenuFindItem(contextMenu, label) {
          var itemText = [...contextMenu.querySelectorAll('.btn-menu-item .btn-menu-item-text')]
              .find(el => el.textContent.includes(label));

          if (!itemText) {
              return null;
          }

          return itemText.closest('.btn-menu-item');
      }

      async function clickDeleteConfirmationButton() {
          // Delete confirmation dialog appears after a while; poll for its button
          var confirmButton = null;
          for (var i = 0; i < 50; i++) {
              confirmButton = [...document.querySelectorAll('button')]
                  .find(b => b.offsetParent && b.textContent.trim() === 'Delete');
              if (confirmButton) { break; }
              await sleepMs(100);
          }
          if (!confirmButton) { throw new Error('No delete confirmation button!'); }
          confirmButton.click();
      }

      async function messageContextMenuAction(labels) {
          // A link inside the hovered bubble has its own context menu: right-click it instead of the bubble
          var targetElement = document.querySelector('.bubble .anchor-url:hover');
          if (!targetElement) {
              targetElement = document.querySelector('.bubble:hover');
          }
          if (!targetElement) {
              throw new Error('No hovered message bubble!');
          }

          // Interface versions differ in item labels: accept synonyms to try in a row
          if (!Array.isArray(labels)) {
              labels = [labels];
          }

          elementMouseRightClick(targetElement);

          var contextMenu = await waitForMessageContextMenu();

          var menuItem = null;
          for (var label of labels) {
              menuItem = contextMenuFindItem(contextMenu, label);
              if (menuItem) {
                break;
              }
          }
          if (!menuItem) {
              throw new Error(`No "${labels.join('" or "')}" message context menu item!`);
          }

          // Focus the item (role="menuitem" tabindex="0") and hold it before clicking
          menuItem.focus();

          await sleepMs(600);

          menuItem.click();
      }

      const messageCopy = async () => {
          try {
              await messageContextMenuAction('Copy');

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const messageCopyLink = async () => {
          try {
              await messageContextMenuAction([
                'Copy Link',
                // 'Copy Message Link'
              ]);

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const messageEdit = async () => {
          try {
              await messageContextMenuAction('Edit');

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const messageRepostDialogOpen = async () => {
          try {
              await messageContextMenuAction('Forward');

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      function pressEnterKey(element) {
          if (!element) {
            element = document;
          }
          for (var eventName of ['keydown', 'keyup']) {
              element.dispatchEvent(new KeyboardEvent(eventName, {
                  bubbles: true, cancelable: true, composed: true,
                  key: 'Enter', code: 'Enter', keyCode: 13, which: 13
              }));
          }
      }

      function inputNativeValue(input, value) {
          // React overwrites the input .value set directly, so use the native HTMLInputElement setter
          var nativeValueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
          nativeValueSetter.call(input, value);
          input.dispatchEvent(new Event('input', { bubbles: true }));
      }

      async function waitForRepostDialogSearchInput() {
          // Unpredictable appearance: poll for a few seconds
          for (var i = 0; i < 20; i++) {
              var searchInput = document.querySelector('input.selector-search-input');
              if (searchInput) {
                  return searchInput;
              }
              await sleepMs(100);
          }

          throw new Error('No repost dialog search input!');
      }

      async function waitForRepostDialogRow(chatName) {
          // Unpredictable appearance: poll for a few seconds
          for (var i = 0; i < 50; i++) {
              var listContainer = document.querySelector('.popup-body .selector-height-container');
              if (listContainer) {
                  // Exact chat title text match, e.g. "/save/"
                  var row = [...listContainer.querySelectorAll('a.row')]
                      .find(el => {
                          var peerTitle = el.querySelector('.peer-title');
                          return peerTitle && peerTitle.textContent.trim() === chatName;
                      });
                  if (row) {
                      return row;
                  }
              }
              await sleepMs(100);
          }

          throw new Error(`No "${chatName}" row in the repost dialog!`);
      }

      async function waitForMessageSendButton() {
          // Unpredictable appearance: poll for a few seconds
          for (var i = 0; i < 50; i++) {
              var sendButton = document.querySelector('.new-message-wrapper button[aria-label="Send"]');
              if (sendButton) {
                  return sendButton;
              }
              await sleepMs(100);
          }

          throw new Error('No message send button!');
      }

      const messageDelete = async () => {
          try {
              await messageContextMenuAction('Delete');
              await clickDeleteConfirmationButton();

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const messageSaferDelete = async () => {
          try {
              // Copy before delete, so the text can be pasted back
              await messageCopy();
              await sleepMs(300);
              await messageDelete();

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const messageAskChatNameToRepost = async (chatName) => {
          try {
              if (!chatName) {
                  chatName = window.prompt('Chat name to move the message to');
                  if (!chatName) { throw new Error('No chat name!'); }
              }

              await messageRepostDialogOpen();

              var searchInput = await waitForRepostDialogSearchInput();
              searchInput.focus();
              inputNativeValue(searchInput, chatName);
              pressEnterKey(searchInput);
              await sleepMs(1200);

              var chatRow = await waitForRepostDialogRow(chatName);
              chatRow.click();
              await sleepMs(1500);
              (await waitForMessageSendButton()).click();

          } catch (e) {
              console.error(logPrefix, e);
          }
      }

      const commands = [
          { name: 'Message: copy under mouse cursor', action: messageCopy },
          { name: 'Message: copy link under mouse cursor', action: messageCopyLink },
          { name: 'Message: edit under mouse cursor', action: messageEdit },
          { name: 'Message: repost under mouse cursor', action: messageRepostDialogOpen },
          { name: 'Message: ask chat name to repost', action: messageAskChatNameToRepost },
          // { name: 'Message: move to /save/ under mouse cursor', action: () => messageMoveToChatAtMouseCursor('/save/') },
          { name: 'Message: /!\\ DELETE under mouse cursor', action: messageDelete },
          { name: 'Message: safer delete under mouse cursor', action: messageSaferDelete },
          // { name: 'Print', action: () => window.print() },
          // { name: 'Alert', action: () => alert('Executed Command 2') }
          // Add more commands here
      ];

      // Delay actions: let the palette close before the page state changes
      const delayedCommands = commands.map(cmd => ({
          name: cmd.name,
          action: async () => {
            await sleepMs(100);
            await cmd.action() }
      }));

      console.log(logPrefix, 'Before commands menu init');

      // initializeCommandPalette() waits for DOMContentLoaded, hence @run-at document-start
      // [P]alette: Ctrl+Alt+P (Ctrl+Shift+H is taken by Firefox history)
      LightCmdPalette.initializeCommandPalette(delayedCommands, [
        {
          shortcutKey: 'P',
          ctrlKey: true,
          shiftKey: false,
          altKey: true
        },
        {
          /** Russian keyboard layout */
          shortcutKey: 'З',
          ctrlKey: true,
          shiftKey: false,
          altKey: true
        }
      ]);

      console.log(logPrefix, 'After commands menu init. Ctrl+Alt+P to run commands');
      // console.log(logPrefix, 'after hotkeys. Warning: You MUST click at least once for hotkeys to work');
  }, 0);

  // commandPalette.css is inlined: a userscript cannot link a local stylesheet
  commandPaletteCss = `
  .command-palette {
      font-family: 'Courier New', Courier, monospace;
      position: fixed;
      top: 25%;
      z-index: 1000;
      background: #111;
      border: 1px solid #444;
      box-shadow: 0 4px 8px rgba(0,0,0,0.8);
      max-width: 600px;
      padding: 0px;
      border-radius: 8px;
      text-wrap: wrap;
      overflow:hidden;
  }

  .command-input {
      font-family: 'Courier New', Courier, monospace;
      width: 100%;
      padding: 10px;
      border: none;
      border-bottom: 1px solid #444;
      border-top-left-radius: 8px;
      border-top-right-radius: 8px;
      margin-bottom: 10px;
      box-sizing: border-box;
  }

  .command-list {
      list-style: none;
      padding: 0;
      margin: 0;
      max-height: 200px;
      overflow-y: auto;
  }

  .command-list li {
      padding: 10px;
      cursor: pointer;
      transition: background-color 0.3s;
  }

  .command-list li:hover, .command-list li.selected {
      background-color: #333;
  }

  .command-palette footer {
      font-size: 12px;
      padding-inline: 10px;
      color: #999;
      border-top: 1px solid #444;
      cursor: pointer;
  }

  .command-palette kbd {
      background-color: #333;
      border: 1px solid #222;
      border-bottom: 2px solid #000;
      border-radius: 3px;
      box-shadow: 0 1px 0 #ccc, 0 0 0 2px #fff inset;
      color: #fff;
      display: inline-block;
      font-family: 'Courier New', Courier, monospace;
      font-size: 11px;
      line-height: 10px;
      padding: 2px 4px;
      white-space: nowrap;
  }
  `;

})();


// (function() {
//     'use strict';
//
//     /** hotkeys-js v3.13.7 required! */
//
//     var logPrefix = 'VK hotkeys d9k userscript:';
//
//     console.log(logPrefix, 'main function');
//
//     // Waiting for deps to load
//     setTimeout(() => {
//         console.log(logPrefix, 'after initial setTimeout to wait for deps to load');
//
//         function sleepMs(ms) {
//             return new Promise(resolve => setTimeout(resolve, ms));
//         }
//
//         function elementMouseHoverForce(element) {
//             var hoverEvents = ['pointerover', 'pointerenter', 'mouseover', 'mouseenter', 'mousemove'];
//             for (var eventName of hoverEvents) {
//                 element.dispatchEvent(new MouseEvent(eventName, { bubbles: true, cancelable: true, view: window }));
//             }
//         }
//
//         var clickMusicAddButton = async () => {
//             try {
//                 var activeRow = document.querySelector('[data-testid="MusicTrackRow_isActive"]');
//
//                 // Paused track has no isActive row; fallback to row containing the progress slider
//                 if (!activeRow) {
//                     activeRow = [...document.querySelectorAll('[data-testid="MusicTrackRow"]')]
//                         .find(row => row.querySelector('[data-testid="slider_input"]'));
//                 }
//
//                 if (!activeRow) {
//                     throw new Error('No activeRow!');
//                 }
//
//                 // Lazy rendering: MenuButton is created only on hover
//                 elementMouseHoverForce(activeRow);
//
//                 await sleepMs(400);
//
//                 var trackMenuButton = activeRow.querySelector('[data-testid="MusicAudio_MenuButton"]');
//
//                 if (!trackMenuButton) {
//                     throw new Error('No trackMenuButton!');
//                 }
//
//                 trackMenuButton.click();
//
//                 await sleepMs(1200);
//
//                 var actionSheet = document.querySelector('[data-testid="MusicTrackRow_ActionSheet"]');
//                 if (!actionSheet) {
//                     throw new Error('No actionSheet!');
//                 }
//
//                 // Unpredictable appearance: poll for a few seconds
//                 var showAllSpan = null;
//
//                 for (var i = 0; i < 50; i++) {
//                     showAllSpan = [...actionSheet.querySelectorAll('span')].find(el => el.textContent.includes('Показать все'));
//                     if (showAllSpan) {
//                         break;
//                     }
//                     await sleepMs(100);
//                 }
//
//                 if (!showAllSpan) {
//                     throw new Error('No showAllSpan!');
//                 }
//
//                 showAllSpan.click();
//
//             } catch (e) {
//                 console.error(logPrefix, 'clickMusicAddButton crashed:', e);
//                 throw e;
//             }
//           }
//
//         // Backup variant: no data-testid; hover the playing track's composite row
//         var clickMusicAddButton2 = async () => {
//             try {
//                 // Playing track's row is the one containing a button with exact aria-label "Поставить на\u00A0паузу"
//                 var compositeRow = [...document.querySelectorAll('[class*="AudioCellCompositeRowsLayout__root"]')]
//                     .find(row => row.querySelector('[aria-label="Поставить на\u00A0паузу"]'));
//
//                 if (!compositeRow) {
//                     throw new Error('No compositeRow!');
//                 }
//
//                 // Action buttons are revealed only on hover of the composite row
//                 elementMouseHoverForce(compositeRow);
//
//                 await sleepMs(200);
//
//                 // Open the popup menu ("Открыть меню"); the add button appears inside it
//                 var menuButton = [...compositeRow.querySelectorAll('button')]
//                     .find(b => b.textContent.includes('Открыть меню'));
//
//                 if (!menuButton) {
//                     throw new Error('No menuButton!');
//                 }
//
//                 menuButton.click();
//
//                 await sleepMs(300);
//
//                 // Unpredictable appearance: poll for a few seconds
//                 var showAllButton = null;
//
//                 for (var i = 0; i < 50; i++) {
//                     // Popup menu renders into a portal: div[role="dialog"] (there may be several)
//                     showAllButton = [...document.querySelectorAll('[role="dialog"] div[role="button"]')]
//                         .find(el => el.textContent.includes('Показать все'));
//                     if (showAllButton) {
//                         break;
//                     }
//                     await sleepMs(100);
//                 }
//
//                 if (!showAllButton) {
//                     throw new Error('No showAllButton!');
//                 }
//
//                 showAllButton.click();
//
//             } catch (e) {
//                 console.error(logPrefix, 'clickMusicAddButton2:', e);
//             }
//           }
//
//         var clickMoreActionsButton = () => {
//             // There are many such buttons; we need the one in the block under the real cursor
//             var moreButton = document.querySelector('.ConvoHistory__messageBlock:hover [data-testid="vkme_messages_actions_button_more"]');
//             if (!moreButton) {
//                 throw new Error('No moreButton!');
//             }
//
//             moreButton.click();
//           }
//
//         var clickReactionLike = async () => {
//             try {
//                 clickMoreActionsButton();
//
//                 await sleepMs(800);
//
//                 var likeButton = document.querySelector('.MessageReactionPickerExtended__item img[alt="Большой палец вверх"]');
//                 if (!likeButton) {
//                     throw new Error('No likeButton!');
//                 }
//
//                 likeButton.click();
//
//             } catch (e) {
//                 console.error(logPrefix, e);
//             }
//           }
//
//         var clickReactionMindBlown = async () => {
//             try {
//                 clickMoreActionsButton();
//
//                 await sleepMs(800);
//
//                 var extendedMoreButton = document.querySelector('.MessageReactionPickerExtended__more');
//                 if (!extendedMoreButton) {
//                     throw new Error('No extendedMoreButton!');
//                 }
//
//                 extendedMoreButton.click();
//
//                 await sleepMs(300);
//
//                 var mindBlownImg = document.querySelector('img[alt="Взрыв мозга"]');
//                 if (!mindBlownImg) {
//                     throw new Error('No mindBlownImg!');
//                 }
//
//                 mindBlownImg.click();
//
//             } catch (e) {
//                 console.error(logPrefix, e);
//             }
//           }
//
//         var clickSaveButton = () => {
//             try {
//                 var saveContentSpan = [...document.querySelectorAll('.vkuiButton__content')]
//                     .find(el => el.textContent.includes('Сохранить'));
//
//                 if (!saveContentSpan) {
//                     throw new Error('No saveContentSpan!');
//                 }
//
//                 saveContentSpan.closest('button').click();
//
//             } catch (e) {
//                 console.error(logPrefix, e);
//             }
//           }
//
//         var clickMusicShareButton = () => {
//             try {
//                 var shareButton = document.querySelector('[data-testid="MusicAudio_Share"]');
//                 if (!shareButton) {
//                     throw new Error('No [data-testid="MusicAudio_Share"] element!');
//                 }
//
//                 shareButton.click();
//
//             } catch (e) {
//                 console.error(logPrefix, e);
//             }
//           }
//
//           console.log(logPrefix, 'before hotkeys');
//
//           /** [R]epost */
//           hotkeys('ctrl+alt+r', (e) => {
//               e.preventDefault();
//               clickMusicShareButton();
//           });
//
//           /** [A]dd to playlist */
//           hotkeys('ctrl+alt+a', (e) => {
//               e.preventDefault();
//               clickMusicAddButton().catch(() => {
//                   console.error(logPrefix, 'running clickMusicAddButton2 after crash');
//                   clickMusicAddButton2();
//               });
//           });
//
//           /** [L]ike */
//           hotkeys('ctrl+alt+l', (e) => {
//               e.preventDefault();
//               clickReactionLike();
//           });
//
//           /** [E]xploding head reaction */
//           hotkeys('ctrl+alt+e', (e) => {
//               e.preventDefault();
//               clickReactionMindBlown();
//           });
//
//           /** [Y]es / save */
//           hotkeys('ctrl+alt+y', (e) => {
//               e.preventDefault();
//               clickSaveButton();
//           });
//
//           console.log(logPrefix, 'after hotkeys. Warning: You MUST click at least once for hotkeys to work');
//     }, 0);
// })();
//

/** ========================== */
/** === DEPENDENCIES BEGIN === */
/** ========================== */

/**!
 * hotkeys-js v3.13.7
 * A simple micro-library for defining and dispatching keyboard shortcuts. It has no dependencies.
 *
 * Copyright (c) 2024 kenny wong <wowohoo@qq.com>
 * https://github.com/jaywcjlove/hotkeys-js.git
 *
 * @website: https://jaywcjlove.github.io/hotkeys-js

 * Licensed under the MIT license
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.hotkeys = factory());
})(this, (function () { 'use strict';

  const isff = typeof navigator !== 'undefined' ? navigator.userAgent.toLowerCase().indexOf('firefox') > 0 : false;

  // 绑定事件
  function addEvent(object, event, method, useCapture) {
    if (object.addEventListener) {
      object.addEventListener(event, method, useCapture);
    } else if (object.attachEvent) {
      object.attachEvent("on".concat(event), method);
    }
  }
  function removeEvent(object, event, method, useCapture) {
    if (object.removeEventListener) {
      object.removeEventListener(event, method, useCapture);
    } else if (object.detachEvent) {
      object.detachEvent("on".concat(event), method);
    }
  }

  // 修饰键转换成对应的键码
  function getMods(modifier, key) {
    const mods = key.slice(0, key.length - 1);
    for (let i = 0; i < mods.length; i++) mods[i] = modifier[mods[i].toLowerCase()];
    return mods;
  }

  // 处理传的key字符串转换成数组
  function getKeys(key) {
    if (typeof key !== 'string') key = '';
    key = key.replace(/\s/g, ''); // 匹配任何空白字符,包括空格、制表符、换页符等等
    const keys = key.split(','); // 同时设置多个快捷键，以','分割
    let index = keys.lastIndexOf('');

    // 快捷键可能包含','，需特殊处理
    for (; index >= 0;) {
      keys[index - 1] += ',';
      keys.splice(index, 1);
      index = keys.lastIndexOf('');
    }
    return keys;
  }

  // 比较修饰键的数组
  function compareArray(a1, a2) {
    const arr1 = a1.length >= a2.length ? a1 : a2;
    const arr2 = a1.length >= a2.length ? a2 : a1;
    let isIndex = true;
    for (let i = 0; i < arr1.length; i++) {
      if (arr2.indexOf(arr1[i]) === -1) isIndex = false;
    }
    return isIndex;
  }

  // Special Keys
  const _keyMap = {
    backspace: 8,
    '⌫': 8,
    tab: 9,
    clear: 12,
    enter: 13,
    '↩': 13,
    return: 13,
    esc: 27,
    escape: 27,
    space: 32,
    left: 37,
    up: 38,
    right: 39,
    down: 40,
    del: 46,
    delete: 46,
    ins: 45,
    insert: 45,
    home: 36,
    end: 35,
    pageup: 33,
    pagedown: 34,
    capslock: 20,
    num_0: 96,
    num_1: 97,
    num_2: 98,
    num_3: 99,
    num_4: 100,
    num_5: 101,
    num_6: 102,
    num_7: 103,
    num_8: 104,
    num_9: 105,
    num_multiply: 106,
    num_add: 107,
    num_enter: 108,
    num_subtract: 109,
    num_decimal: 110,
    num_divide: 111,
    '⇪': 20,
    ',': 188,
    '.': 190,
    '/': 191,
    '`': 192,
    '-': isff ? 173 : 189,
    '=': isff ? 61 : 187,
    ';': isff ? 59 : 186,
    '\'': 222,
    '[': 219,
    ']': 221,
    '\\': 220
  };

  // Modifier Keys
  const _modifier = {
    // shiftKey
    '⇧': 16,
    shift: 16,
    // altKey
    '⌥': 18,
    alt: 18,
    option: 18,
    // ctrlKey
    '⌃': 17,
    ctrl: 17,
    control: 17,
    // metaKey
    '⌘': 91,
    cmd: 91,
    command: 91
  };
  const modifierMap = {
    16: 'shiftKey',
    18: 'altKey',
    17: 'ctrlKey',
    91: 'metaKey',
    shiftKey: 16,
    ctrlKey: 17,
    altKey: 18,
    metaKey: 91
  };
  const _mods = {
    16: false,
    18: false,
    17: false,
    91: false
  };
  const _handlers = {};

  // F1~F12 special key
  for (let k = 1; k < 20; k++) {
    _keyMap["f".concat(k)] = 111 + k;
  }

  let _downKeys = []; // 记录摁下的绑定键
  let winListendFocus = null; // window是否已经监听了focus事件
  let _scope = 'all'; // 默认热键范围
  const elementEventMap = new Map(); // 已绑定事件的节点记录

  // 返回键码
  const code = x => _keyMap[x.toLowerCase()] || _modifier[x.toLowerCase()] || x.toUpperCase().charCodeAt(0);
  const getKey = x => Object.keys(_keyMap).find(k => _keyMap[k] === x);
  const getModifier = x => Object.keys(_modifier).find(k => _modifier[k] === x);

  // 设置获取当前范围（默认为'所有'）
  function setScope(scope) {
    _scope = scope || 'all';
  }
  // 获取当前范围
  function getScope() {
    return _scope || 'all';
  }
  // 获取摁下绑定键的键值
  function getPressedKeyCodes() {
    return _downKeys.slice(0);
  }
  function getPressedKeyString() {
    return _downKeys.map(c => getKey(c) || getModifier(c) || String.fromCharCode(c));
  }
  function getAllKeyCodes() {
    const result = [];
    Object.keys(_handlers).forEach(k => {
      _handlers[k].forEach(_ref => {
        let {
          key,
          scope,
          mods,
          shortcut
        } = _ref;
        result.push({
          scope,
          shortcut,
          mods,
          keys: key.split('+').map(v => code(v))
        });
      });
    });
    return result;
  }

  // 表单控件控件判断 返回 Boolean
  // hotkey is effective only when filter return true
  function filter(event) {
    const target = event.target || event.srcElement;
    const {
      tagName
    } = target;
    let flag = true;
    const isInput = tagName === 'INPUT' && !['checkbox', 'radio', 'range', 'button', 'file', 'reset', 'submit', 'color'].includes(target.type);
    // ignore: isContentEditable === 'true', <input> and <textarea> when readOnly state is false, <select>
    if (target.isContentEditable || (isInput || tagName === 'TEXTAREA' || tagName === 'SELECT') && !target.readOnly) {
      flag = false;
    }
    return flag;
  }

  // 判断摁下的键是否为某个键，返回true或者false
  function isPressed(keyCode) {
    if (typeof keyCode === 'string') {
      keyCode = code(keyCode); // 转换成键码
    }
    return _downKeys.indexOf(keyCode) !== -1;
  }

  // 循环删除handlers中的所有 scope(范围)
  function deleteScope(scope, newScope) {
    let handlers;
    let i;

    // 没有指定scope，获取scope
    if (!scope) scope = getScope();
    for (const key in _handlers) {
      if (Object.prototype.hasOwnProperty.call(_handlers, key)) {
        handlers = _handlers[key];
        for (i = 0; i < handlers.length;) {
          if (handlers[i].scope === scope) {
            const deleteItems = handlers.splice(i, 1);
            deleteItems.forEach(_ref2 => {
              let {
                element
              } = _ref2;
              return removeKeyEvent(element);
            });
          } else {
            i++;
          }
        }
      }
    }

    // 如果scope被删除，将scope重置为all
    if (getScope() === scope) setScope(newScope || 'all');
  }

  // 清除修饰键
  function clearModifier(event) {
    let key = event.keyCode || event.which || event.charCode;
    const i = _downKeys.indexOf(key);

    // 从列表中清除按压过的键
    if (i >= 0) {
      _downKeys.splice(i, 1);
    }
    // 特殊处理 cmmand 键，在 cmmand 组合快捷键 keyup 只执行一次的问题
    if (event.key && event.key.toLowerCase() === 'meta') {
      _downKeys.splice(0, _downKeys.length);
    }

    // 修饰键 shiftKey altKey ctrlKey (command||metaKey) 清除
    if (key === 93 || key === 224) key = 91;
    if (key in _mods) {
      _mods[key] = false;

      // 将修饰键重置为false
      for (const k in _modifier) if (_modifier[k] === key) hotkeys[k] = false;
    }
  }
  function unbind(keysInfo) {
    // unbind(), unbind all keys
    if (typeof keysInfo === 'undefined') {
      Object.keys(_handlers).forEach(key => {
        Array.isArray(_handlers[key]) && _handlers[key].forEach(info => eachUnbind(info));
        delete _handlers[key];
      });
      removeKeyEvent(null);
    } else if (Array.isArray(keysInfo)) {
      // support like : unbind([{key: 'ctrl+a', scope: 's1'}, {key: 'ctrl-a', scope: 's2', splitKey: '-'}])
      keysInfo.forEach(info => {
        if (info.key) eachUnbind(info);
      });
    } else if (typeof keysInfo === 'object') {
      // support like unbind({key: 'ctrl+a, ctrl+b', scope:'abc'})
      if (keysInfo.key) eachUnbind(keysInfo);
    } else if (typeof keysInfo === 'string') {
      for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        args[_key - 1] = arguments[_key];
      }
      // support old method
      // eslint-disable-line
      let [scope, method] = args;
      if (typeof scope === 'function') {
        method = scope;
        scope = '';
      }
      eachUnbind({
        key: keysInfo,
        scope,
        method,
        splitKey: '+'
      });
    }
  }

  // 解除绑定某个范围的快捷键
  const eachUnbind = _ref3 => {
    let {
      key,
      scope,
      method,
      splitKey = '+'
    } = _ref3;
    const multipleKeys = getKeys(key);
    multipleKeys.forEach(originKey => {
      const unbindKeys = originKey.split(splitKey);
      const len = unbindKeys.length;
      const lastKey = unbindKeys[len - 1];
      const keyCode = lastKey === '*' ? '*' : code(lastKey);
      if (!_handlers[keyCode]) return;
      // 判断是否传入范围，没有就获取范围
      if (!scope) scope = getScope();
      const mods = len > 1 ? getMods(_modifier, unbindKeys) : [];
      const unbindElements = [];
      _handlers[keyCode] = _handlers[keyCode].filter(record => {
        // 通过函数判断，是否解除绑定，函数相等直接返回
        const isMatchingMethod = method ? record.method === method : true;
        const isUnbind = isMatchingMethod && record.scope === scope && compareArray(record.mods, mods);
        if (isUnbind) unbindElements.push(record.element);
        return !isUnbind;
      });
      unbindElements.forEach(element => removeKeyEvent(element));
    });
  };

  // 对监听对应快捷键的回调函数进行处理
  function eventHandler(event, handler, scope, element) {
    if (handler.element !== element) {
      return;
    }
    let modifiersMatch;

    // 看它是否在当前范围
    if (handler.scope === scope || handler.scope === 'all') {
      // 检查是否匹配修饰符（如果有返回true）
      modifiersMatch = handler.mods.length > 0;
      for (const y in _mods) {
        if (Object.prototype.hasOwnProperty.call(_mods, y)) {
          if (!_mods[y] && handler.mods.indexOf(+y) > -1 || _mods[y] && handler.mods.indexOf(+y) === -1) {
            modifiersMatch = false;
          }
        }
      }

      // 调用处理程序，如果是修饰键不做处理
      if (handler.mods.length === 0 && !_mods[16] && !_mods[18] && !_mods[17] && !_mods[91] || modifiersMatch || handler.shortcut === '*') {
        handler.keys = [];
        handler.keys = handler.keys.concat(_downKeys);
        if (handler.method(event, handler) === false) {
          if (event.preventDefault) event.preventDefault();else event.returnValue = false;
          if (event.stopPropagation) event.stopPropagation();
          if (event.cancelBubble) event.cancelBubble = true;
        }
      }
    }
  }

  // 处理keydown事件
  function dispatch(event, element) {
    const asterisk = _handlers['*'];
    let key = event.keyCode || event.which || event.charCode;

    // 表单控件过滤 默认表单控件不触发快捷键
    if (!hotkeys.filter.call(this, event)) return;

    // Gecko(Firefox)的command键值224，在Webkit(Chrome)中保持一致
    // Webkit左右 command 键值不一样
    if (key === 93 || key === 224) key = 91;

    /**
     * Collect bound keys
     * If an Input Method Editor is processing key input and the event is keydown, return 229.
     * https://stackoverflow.com/questions/25043934/is-it-ok-to-ignore-keydown-events-with-keycode-229
     * http://lists.w3.org/Archives/Public/www-dom/2010JulSep/att-0182/keyCode-spec.html
     */
    if (_downKeys.indexOf(key) === -1 && key !== 229) _downKeys.push(key);
    /**
     * Jest test cases are required.
     * ===============================
     */
    ['ctrlKey', 'altKey', 'shiftKey', 'metaKey'].forEach(keyName => {
      const keyNum = modifierMap[keyName];
      if (event[keyName] && _downKeys.indexOf(keyNum) === -1) {
        _downKeys.push(keyNum);
      } else if (!event[keyName] && _downKeys.indexOf(keyNum) > -1) {
        _downKeys.splice(_downKeys.indexOf(keyNum), 1);
      } else if (keyName === 'metaKey' && event[keyName] && _downKeys.length === 3) {
        /**
         * Fix if Command is pressed:
         * ===============================
         */
        if (!(event.ctrlKey || event.shiftKey || event.altKey)) {
          _downKeys = _downKeys.slice(_downKeys.indexOf(keyNum));
        }
      }
    });
    /**
     * -------------------------------
     */

    if (key in _mods) {
      _mods[key] = true;

      // 将特殊字符的key注册到 hotkeys 上
      for (const k in _modifier) {
        if (_modifier[k] === key) hotkeys[k] = true;
      }
      if (!asterisk) return;
    }

    // 将 modifierMap 里面的修饰键绑定到 event 中
    for (const e in _mods) {
      if (Object.prototype.hasOwnProperty.call(_mods, e)) {
        _mods[e] = event[modifierMap[e]];
      }
    }
    /**
     * https://github.com/jaywcjlove/hotkeys/pull/129
     * This solves the issue in Firefox on Windows where hotkeys corresponding to special characters would not trigger.
     * An example of this is ctrl+alt+m on a Swedish keyboard which is used to type μ.
     * Browser support: https://caniuse.com/#feat=keyboardevent-getmodifierstate
     */
    if (event.getModifierState && !(event.altKey && !event.ctrlKey) && event.getModifierState('AltGraph')) {
      if (_downKeys.indexOf(17) === -1) {
        _downKeys.push(17);
      }
      if (_downKeys.indexOf(18) === -1) {
        _downKeys.push(18);
      }
      _mods[17] = true;
      _mods[18] = true;
    }

    // 获取范围 默认为 `all`
    const scope = getScope();
    // 对任何快捷键都需要做的处理
    if (asterisk) {
      for (let i = 0; i < asterisk.length; i++) {
        if (asterisk[i].scope === scope && (event.type === 'keydown' && asterisk[i].keydown || event.type === 'keyup' && asterisk[i].keyup)) {
          eventHandler(event, asterisk[i], scope, element);
        }
      }
    }
    // key 不在 _handlers 中返回
    if (!(key in _handlers)) return;
    const handlerKey = _handlers[key];
    const keyLen = handlerKey.length;
    for (let i = 0; i < keyLen; i++) {
      if (event.type === 'keydown' && handlerKey[i].keydown || event.type === 'keyup' && handlerKey[i].keyup) {
        if (handlerKey[i].key) {
          const record = handlerKey[i];
          const {
            splitKey
          } = record;
          const keyShortcut = record.key.split(splitKey);
          const _downKeysCurrent = []; // 记录当前按键键值
          for (let a = 0; a < keyShortcut.length; a++) {
            _downKeysCurrent.push(code(keyShortcut[a]));
          }
          if (_downKeysCurrent.sort().join('') === _downKeys.sort().join('')) {
            // 找到处理内容
            eventHandler(event, record, scope, element);
          }
        }
      }
    }
  }
  function hotkeys(key, option, method) {
    _downKeys = [];
    const keys = getKeys(key); // 需要处理的快捷键列表
    let mods = [];
    let scope = 'all'; // scope默认为all，所有范围都有效
    let element = document; // 快捷键事件绑定节点
    let i = 0;
    let keyup = false;
    let keydown = true;
    let splitKey = '+';
    let capture = false;
    let single = false; // 单个callback

    // 对为设定范围的判断
    if (method === undefined && typeof option === 'function') {
      method = option;
    }
    if (Object.prototype.toString.call(option) === '[object Object]') {
      if (option.scope) scope = option.scope; // eslint-disable-line
      if (option.element) element = option.element; // eslint-disable-line
      if (option.keyup) keyup = option.keyup; // eslint-disable-line
      if (option.keydown !== undefined) keydown = option.keydown; // eslint-disable-line
      if (option.capture !== undefined) capture = option.capture; // eslint-disable-line
      if (typeof option.splitKey === 'string') splitKey = option.splitKey; // eslint-disable-line
      if (option.single === true) single = true; // eslint-disable-line
    }
    if (typeof option === 'string') scope = option;

    // 如果只允许单个callback，先unbind
    if (single) unbind(key, scope);

    // 对于每个快捷键进行处理
    for (; i < keys.length; i++) {
      key = keys[i].split(splitKey); // 按键列表
      mods = [];

      // 如果是组合快捷键取得组合快捷键
      if (key.length > 1) mods = getMods(_modifier, key);

      // 将非修饰键转化为键码
      key = key[key.length - 1];
      key = key === '*' ? '*' : code(key); // *表示匹配所有快捷键

      // 判断key是否在_handlers中，不在就赋一个空数组
      if (!(key in _handlers)) _handlers[key] = [];
      _handlers[key].push({
        keyup,
        keydown,
        scope,
        mods,
        shortcut: keys[i],
        method,
        key: keys[i],
        splitKey,
        element
      });
    }
    // 在全局document上设置快捷键
    if (typeof element !== 'undefined' && window) {
      if (!elementEventMap.has(element)) {
        const keydownListener = function () {
          let event = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : window.event;
          return dispatch(event, element);
        };
        const keyupListenr = function () {
          let event = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : window.event;
          dispatch(event, element);
          clearModifier(event);
        };
        elementEventMap.set(element, {
          keydownListener,
          keyupListenr,
          capture
        });
        addEvent(element, 'keydown', keydownListener, capture);
        addEvent(element, 'keyup', keyupListenr, capture);
      }
      if (!winListendFocus) {
        const listener = () => {
          _downKeys = [];
        };
        winListendFocus = {
          listener,
          capture
        };
        addEvent(window, 'focus', listener, capture);
      }
    }
  }
  function trigger(shortcut) {
    let scope = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'all';
    Object.keys(_handlers).forEach(key => {
      const dataList = _handlers[key].filter(item => item.scope === scope && item.shortcut === shortcut);
      dataList.forEach(data => {
        if (data && data.method) {
          data.method();
        }
      });
    });
  }

  // 销毁事件,unbind之后判断element上是否还有键盘快捷键，如果没有移除监听
  function removeKeyEvent(element) {
    const values = Object.values(_handlers).flat();
    const findindex = values.findIndex(_ref4 => {
      let {
        element: el
      } = _ref4;
      return el === element;
    });
    if (findindex < 0) {
      const {
        keydownListener,
        keyupListenr,
        capture
      } = elementEventMap.get(element) || {};
      if (keydownListener && keyupListenr) {
        removeEvent(element, 'keyup', keyupListenr, capture);
        removeEvent(element, 'keydown', keydownListener, capture);
        elementEventMap.delete(element);
      }
    }
    if (values.length <= 0 || elementEventMap.size <= 0) {
      // 移除所有的元素上的监听
      const eventKeys = Object.keys(elementEventMap);
      eventKeys.forEach(el => {
        const {
          keydownListener,
          keyupListenr,
          capture
        } = elementEventMap.get(el) || {};
        if (keydownListener && keyupListenr) {
          removeEvent(el, 'keyup', keyupListenr, capture);
          removeEvent(el, 'keydown', keydownListener, capture);
          elementEventMap.delete(el);
        }
      });
      // 清空 elementEventMap
      elementEventMap.clear();
      // 清空 _handlers
      Object.keys(_handlers).forEach(key => delete _handlers[key]);
      // 移除window上的focus监听
      if (winListendFocus) {
        const {
          listener,
          capture
        } = winListendFocus;
        removeEvent(window, 'focus', listener, capture);
        winListendFocus = null;
      }
    }
  }
  const _api = {
    getPressedKeyString,
    setScope,
    getScope,
    deleteScope,
    getPressedKeyCodes,
    getAllKeyCodes,
    isPressed,
    filter,
    trigger,
    unbind,
    keyMap: _keyMap,
    modifier: _modifier,
    modifierMap
  };
  for (const a in _api) {
    if (Object.prototype.hasOwnProperty.call(_api, a)) {
      hotkeys[a] = _api[a];
    }
  }
  if (typeof window !== 'undefined') {
    const _hotkeys = window.hotkeys;
    hotkeys.noConflict = deep => {
      if (deep && window.hotkeys === hotkeys) {
        window.hotkeys = _hotkeys;
      }
      return hotkeys;
    };
    window.hotkeys = hotkeys;
  }

  return hotkeys;

}));
/** ========================== */
/** === COMMAND PALETTE ====== */
/** ========================== */
var LightCmdPalette = (() => {
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

  // src/commandPalette.js
  var commandPalette_exports = {};
  __export(commandPalette_exports, {
    initializeCommandPalette: () => initializeCommandPalette
  });
  function initializeCommandPalette(commands, options = {}) {
    const defaultOptions = {
      shortcutKey: "H",
      // Default key
      ctrlKey: true,
      // Use Ctrl key
      shiftKey: true,
      // Use Shift key
      altKey: false
      // Do not use Alt key by default
    };
    const configs = (Array.isArray(options) ? options : [options]).map((option) => ({ ...defaultOptions, ...option }));
    const matchesConfig = (event, config) => config.ctrlKey === event.ctrlKey && config.shiftKey === event.shiftKey && config.altKey === event.altKey && event.key.toUpperCase() === config.shortcutKey.toUpperCase();
    document.addEventListener("DOMContentLoaded", () => {
      const dialog = document.createElement("dialog");
      dialog.id = "command-palette";
      dialog.className = "command-palette";
      dialog.innerHTML = `
            <input type="text" id="command-input" class="command-input" placeholder="Type a command...">
            <ul id="command-list" class="command-list"></ul>
            <footer title="Click to close">
                <p>Press <kbd>\u21B5</kbd> to select, <kbd>\u2191</kbd> <kbd>\u2193</kbd> to navigate, <kbd>Esc</kbd> to exit</p>
            </footer>
        `;
      document.body.appendChild(dialog);
      const commandInput = document.getElementById("command-input");
      const commandList = document.getElementById("command-list");
      dialog.querySelector("footer").addEventListener("click", () => {
        closeCommandPalette();
      });
      let currentIndex = -1;
      function openCommandPalette() {
        document.getElementById("command-palette").open = true;
        commandInput.focus();
        updateCommandList("");
      }
      function closeCommandPalette() {
        document.getElementById("command-palette").open = false;
        commandInput.value = "";
        currentIndex = -1;
      }
      function updateCommandList(input) {
        commandList.innerHTML = "";
        const filteredCommands = input ? commands.filter((cmd) => cmd.name.toLowerCase().includes(input.toLowerCase())) : commands;
        filteredCommands.forEach((cmd, index) => {
          const li = document.createElement("li");
          li.textContent = cmd.name;
          li.onclick = () => {
            cmd.action();
            closeCommandPalette();
          };
          if (index === currentIndex) {
            li.classList.add("selected");
          }
          commandList.appendChild(li);
        });
      }
      commandInput.addEventListener("input", (e) => updateCommandList(e.target.value));
      document.addEventListener("keydown", (event) => {
        if (!dialog.open) return;
        const items = commandList.getElementsByTagName("li");
        if (event.key === "ArrowDown") {
          event.preventDefault();
          event.stopImmediatePropagation();
          currentIndex = (currentIndex + 1) % items.length;
          updateCommandList(commandInput.value);
          return false;
        } else if (event.key === "ArrowUp") {
          event.preventDefault();
          event.stopImmediatePropagation();
          if (currentIndex <= 0) currentIndex = items.length;
          currentIndex = (currentIndex - 1) % items.length;
          updateCommandList(commandInput.value);
          return false;
        } else if (event.key === "Enter" && currentIndex >= 0) {
          event.preventDefault();
          event.stopImmediatePropagation();
          items[currentIndex].click();
          return false;
        } else if (event.key === "Escape") {
          event.preventDefault();
          event.stopImmediatePropagation();
          closeCommandPalette();
          return false;
        }
      }, { capture: true });
      document.addEventListener("keydown", (event) => {
        if (configs.some((config) => matchesConfig(event, config))) {
          event.preventDefault();
          event.stopImmediatePropagation();
          if (dialog.open) {
            closeCommandPalette();
          } else {
            openCommandPalette();
          }
          return false;
        }
      }, { capture: true });
    });
  }
  return __toCommonJS(commandPalette_exports);
})();