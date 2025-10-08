// MCP Landing Preview Plugin
// Shows live preview of generated landing pages and allows approval/rejection

// Show the plugin UI
figma.showUI(__html__, {
  width: 500,
  height: 700,
  title: "Landing Page Preview"
});

// Listen for messages from the UI
figma.ui.onmessage = async (msg) => {
  if (msg.type === 'get-file-info') {
    // Send file information to UI
    figma.ui.postMessage({
      type: 'file-info',
      data: {
        fileName: figma.root.name,
        fileKey: figma.fileKey || 'unknown',
        selection: figma.currentPage.selection.map(node => ({
          id: node.id,
          name: node.name,
          type: node.type
        }))
      }
    });
  }

  if (msg.type === 'close-plugin') {
    figma.closePlugin();
  }

  if (msg.type === 'notify') {
    figma.notify(msg.message, { timeout: msg.timeout || 2000 });
  }

  if (msg.type === 'get-selection') {
    const selection = figma.currentPage.selection;
    if (selection.length === 0) {
      figma.ui.postMessage({
        type: 'selection-info',
        data: null
      });
    } else {
      figma.ui.postMessage({
        type: 'selection-info',
        data: {
          name: selection[0].name,
          id: selection[0].id,
          type: selection[0].type
        }
      });
    }
  }
};

// Listen for selection changes
figma.on('selectionchange', () => {
  const selection = figma.currentPage.selection;
  if (selection.length > 0) {
    figma.ui.postMessage({
      type: 'selection-changed',
      data: {
        name: selection[0].name,
        id: selection[0].id,
        type: selection[0].type
      }
    });
  } else {
    figma.ui.postMessage({
      type: 'selection-changed',
      data: null
    });
  }
});
