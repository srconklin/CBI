<!--- x-data="{showBreadCrumb : true}"  --->
<!--- <div id="bc-container" class="bc-container" > --->
<!--- <div id="togglebc" class="togglebc" :class="{ 'togglebc-closed-pos': !showBreadCrumb }">
      <button class="ais-Panel-collapseButton" @click.prevent="showBreadCrumb = !showBreadCrumb;">
        <span>
          <svg class="ais-Panel-collapseIcon" width="1em" height="1em" viewBox="0 0 500 500" x-show="showBreadCrumb" >
            <path d="M250 400l150-300H100z" fill="currentColor"></path>
          </svg>
        </span>
        <span>
          <svg class="ais-Panel-collapseIcon" width="1em" height="1em" viewBox="0 0 500 500" x-show="!showBreadCrumb">
            <path d="M100 250l300-150v300z" fill="currentColor"></path>
          </svg>
        </span>
      </button> --->
<!--- </div>  --->

<!--- :class="{ 'hidden': !showBreadCrumb }" --->

<!--- </div> --->

<div id="home">
  <h1>Hello There!</h1>
  <p>Welcome to the CBI online</p>
</div>

<div id="algolia">
<!--- breadcrumb --->
<div class="breadcrumb">
  <div id="breadcrumb"></div>
</div>

<!--- search results main wrapper --->
<div class="search-results" x-data="{showFilter : false}"  :class="{ 'filtermode': showFilter }">

  <!--- show/hide filters (red button) --->
  <div class="filterbar" :class="{'remove-margin' : showFilter}">
    <button class="filter btn btn-red" :class="{'opened' : showFilter}" type="button"
      @click.prevent="$dispatch('blur-bg', !showFilter);showFilter = !showFilter">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
          d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
      </svg>
      <span x-show="!showFilter">show filters</span>
      <span x-show="showFilter">hide filters</span>
    </button>
  </div>

  <!--- refinements (left panel sidebar)  --->
  <div :class="{ 'hidden': !showFilter }" class="left-panel">
    <div class="dash">
      <h3 x-show="!showFilter">Filters</h3>
      <div id="statsfilter"></div>
      <div id="clear-refinements"></div>
    </div>
    <div class="refinement-container">
      <div id="categories"></div>
      <div id="mfr"></div>
    </div>
  </div>

  <!--- hit results (right panel sidebar) --->
  <div class="search-panel" :class="{ 'hidden': showFilter }">
    <!--- <div class="search-panel__results"> --->
      <div class="dashboard">
        <div id="stats"></div>
        <div id="sort-by"></div>
      </div>
      <div id="hits"></div>
      <div id="pagination"></div>
    <!--- </div> --->
  </div>

</div>
</div>

<cfoutput>
  #view( 'common/fragment/QuickView')#
</cfoutput>
