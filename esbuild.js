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
const file = './layouts/default.cfm';

console.log('build mode',  process.env.NODE_ENV);

// rewrite the index page with the style and javascript references updated with the new hashed assets
const rewriteIndex = (assets) => {
  fs.readFile(file, 'utf8', function (err,data) {
    if (err) return console.log(err);
    console.log('replacing new hashes', assets)
    var result = data.replace(/dist\/app[-A-Z0-9]*\.css/g, assets.css);
    result = result.replace(/dist\/app[-A-Z0-9]*\.js/g, assets.js);

    fs.writeFile(file, result, 'utf8', function (err) {
      if (err) return console.log(err);
    });

  });
}

// read metafile get generated hash name for the assets and update the refernces in html file
const updateAssets = {
name: 'updateAssets',
setup(build) {
  build.onEnd(result => {
    const files = result?.metafile?.outputs || {};
    if (files) {
      Object.keys(files).forEach(file => {
        if ( result.metafile.outputs[file].entryPoint) {
          console.log('Parsing entrypoint', file)  
          rewriteIndex({
            css: result.metafile.outputs[file].cssBundle,
            js: file
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
    entryPoints: ['./src/app.js'],
    bundle: true,
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

