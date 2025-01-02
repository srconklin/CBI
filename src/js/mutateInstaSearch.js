// Function to initialize landing page elements
export function mutateInstaSearch() {

  // if (window.isElementVisible('#algolia')) {
  if (document.getElementById('algolia')) {
  
    const breadcrumbContainer = document.querySelector('#breadcrumb');
  
    if (breadcrumbContainer) {
    
        const observer = new MutationObserver(mutations => {
          mutations.forEach(mutation => {
            console.log(mutation);

            if (mutation.addedNodes.length) {
              const nonClickableElement = document.querySelector('.non-clickable');
    
              if (nonClickableElement) {
                const parentAnchor = nonClickableElement.closest('.ais-Breadcrumb-link');
    
                if (parentAnchor) {
                  parentAnchor.classList.add('non-clickable');
                  observer.disconnect(); // Stop observing once done
                  console.log('Breadcrumb root rewritten');
                }
              }
            }
          });
        });
    
        observer.observe(document.getElementById('algolia'), { childList: true, subtree: true });

      } else {
        
        console.log('Breadcrumb container not found.');
      }

  }

}
  