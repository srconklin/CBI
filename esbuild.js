// esbuild src/app.js --bundle --loader:.png=file --entry-names=[dir]/[name]-[hash] --metafile=meta.json --outdir=dist --minify  --target=chrome58,edge16,firefox57,node12,safari11
// esbuild src/app.js --bundle --loader:.png=file --outdir=dist --minify --watch --sourcemap  --target=chrome58,edge16,firefox57,node12,safari11
//const isProduction = process.env.NODE_ENV == 'production'

const path = require('path');
const fs = require('fs');
const esbuild = require('esbuild');
const autoprefixer = require("autoprefixer");
const postCssPlugin = require("@deanc/esbuild-plugin-postcss");
const glob = require('glob');
const isProduction = process.env.NODE_ENV == 'production';
const pathPattern = path.join(__dirname, "/dist/[!m]*").replace(/\\/g, '/');
const files = {
    'app' :  './layouts/default.cfm',
    'aac' :  './views/myprofile/default.cfm'
  };

console.log('build mode',  process.env.NODE_ENV);

// rewrite the index page with the style and javascript references updated with the new hashed assets
const rewriteHTMLFile = (assets) => {
  fs.readFile(assets.htmlFile, 'utf8', function (err,data) {
    if (err) return console.log(err);
    console.log('replacing new hashes', assets)
    var result = data.replace(/dist\/[a-z-A-Z0-9]*\.css/g, assets.css);
    result = result.replace(/dist\/[a-z-A-Z0-9]*\.js/g, assets.js);

    fs.writeFile(assets.htmlFile, result, 'utf8', function (err) {
      console.log('rewriting file', assets.htmlFile);
      if (err) return console.log(err);
    });

  });
}

// read metafile get generated hash name for the assets and update the references in html file
const updateAssets = {
name: 'updateAssets',
setup(build) {
  build.onEnd(result => {
    const theFiles = result?.metafile?.outputs || {};
    if (theFiles) {
      Object.keys(theFiles).forEach(file => {
        if ( result.metafile.outputs[file].entryPoint) {
          console.log('Parsing entrypoint', file) ;
          rewriteHTMLFile({
            css: result.metafile.outputs[file].cssBundle,
            js: file,
            htmlFile: files[result.metafile.outputs[file].entryPoint.substring(4, 7)]
          })
        } 
      })
      
    }
  })
}
}

const buildStarted = {
name: 'buildStarted',
setup(build) {
  build.onStart(() => {
     glob(pathPattern, (err, matches) => {
     if (err) {
          console.error("Error when globbing: " + pathPattern);
        } else {
         matches.forEach((path) => {
           fs.unlink(path, (err) => {
            if (err) {

              console.log(err); 
              console.log('file could not be deleted', path); 

            } 
            else 
              console.log("Deleted file: " +path);
           });
        });
        }
      });
    console.log('cleaning assets folder');

  })
},
}

// autoprefixer only on production build
const applugin = isProduction ? [postCssPlugin({plugins: [autoprefixer]})] : [];
const plugins = [buildStarted, ...applugin, updateAssets]

const config = {
    entryPoints: ['./src/app.js', './src/aac.js'],
    bundle: true,
    external: ["*.jpg"],
    sourcemap: !isProduction,
    logLevel: 'info',
    // entryNames: isProduction ? '[dir]/[name]-[hash]' : '[dir]/[name]',
    entryNames: '[dir]/[name]-[hash]',
    minify: isProduction,
    watch: !isProduction,

    loader: { '.png': 'file' },
   // target: ['chrome58', 'firefox57', 'safari11', 'edge16'],
   target: ['chrome58', 'firefox57', 'edge18', 'safari11'],
    outdir: 'dist',
    metafile:true,
    plugins : plugins
}

esbuild.build(config)
  // .then((result) => {
  //   isProduction ? console.log(result)
  //   // : console.log('watching..')
  // })
  .then((result)=> {
    fs.writeFileSync(
      path.join(__dirname, "/dist/metafile.json"),
      JSON.stringify(result.metafile, null, 4)
    );
  })
  .catch((e) => {
    console.log("Error building:", e.message);
    process.exit(1);
  })

