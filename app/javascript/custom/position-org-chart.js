// the tolerance is needed to tackle inaccuracy due to rounding pixels
const TOLERANCE_PX = 0.01;

const positionOrgChart = () => {
  // define a radius for all elements
  // TODO: Do I need the 'Array.from()'?
  const orgchart = document.querySelector('.orgchart');
  if (!orgchart) {
    return;
  }

  const elements = Array.from(document.querySelectorAll('.circle-0,.subcircle, .role'));
  elements.forEach(e => e.r = e.clientWidth/2);

  // console.log(elements);
  // console.log(elements[0]);

  // define center of gcc
  const GCC = document.querySelector('.circle-0');
  const GCCRect = GCC.getBoundingClientRect();
  GCC.center = {
    x: GCCRect.width/2,
    y: GCCRect.height/2
  };

  // NOW FOR TESTING THE ALG FOR THE FIRST LEVEL:
  // TODO: call algorithm for subcircles
  // const children = document.querySelectorAll('.circle-1, .role-0');
  // const childrenArray = Array.from(children);
  // positionChildren(GCC, GCC, childrenArray);

  const subcircles = document.querySelectorAll('.subcircle');


  positionChildren(GCC, GCC, Array.from(GCC.children));

  subcircles.forEach(c => {
    const children = Array.from(c.children);
    positionChildren(GCC, c, children);
  });

};

// *******************
// ** THE ALGORITHM **
// *******************

// Ideas on how to optimize this algorithm:
// ****************************************
// 1. Sort the children (to be placed) by size, ascending.
//    Then, when possible new centers for a new child, first check
//    whether the center is lower than the center of the last
//    positioned child. If so, it is invalid (and you don't need
//    to check for validity in any other, more complicated, way)

// attributes we need for a circle:
// -x and y, only for the parent circle --> gets defined in the algorithm (except for GCC which I defined above)
// - .style.bottom, only for the pc /*its lowest x coordinate*/ --> gets defined in the algorithm (except for GCC, and there I have a fallback)
// -r /*radius*/

// this algorithm runs for each circle, starting with the GCC

// given:
// - GCC
// - pc (parent circle, js object),
// - children (all direct subcircles and roles, js objects)

function positionChildren(GCC, pc, children) {
  if (children.length === 0) {
    // console.log('children.length is zero!');
    return;
  }

  // overwrite the old center of the parent circle such that it's now
  // relative to itself (and not its parent circle)
  pc.center.x = pc.clientWidth/2;
  pc.center.y = pc.clientHeight/2;

  // position the first child at the bottom of its parent circle
  const firstChild = children[0];
  // firstChild.bottom = (pc === GCC ? 0 : pc.bottom);
  firstChild.bottom = 0;
  firstChild.style.bottom = `${firstChild.bottom}px`; /* pc.style.bottom = lowest x coordinate of pc; GCC.*/
  firstChild.left = (pc.center.x - firstChild.r);
  firstChild.style.left = `${firstChild.left}px`;
  firstChild.center = {x: pc.center.x, y: pc.clientHeight - firstChild.r};

  // let lastPlacedCenter = firstChild.center;

  // CONSOLE LOG FOR TESTING
  // console.log('first child has been positioned:');
  // console.log('x:' + firstChild.center.x);
  // console.log('y:' + firstChild.center.y);
  // console.log('r:' + firstChild.r);

  const placedChildren = [firstChild];
  const remainingChildren = children.slice(1);

  // find a position (center) for all remaining children
  remainingChildren.forEach(c => {
    // console.log(`remainingChildren.forEach() started with:`);
    // console.log(c);
    let newCenter = {};
    // define a circle around the center of pc
    const e = {
      r: pc.r - c.r,
      center: {
        x: pc.center.x,
        y: pc.center.y
      }
    };
    // console.log('defined first distanceKeeper (around center of pc)');
    // console.log(e);

    // define circles around the centers of all placed children
    const distanceKeepers = [];
    placedChildren.forEach(placed => {
      let dk = {
        r: placed.r + c.r,
        center: {
          x: placed.center.x,
          y: placed.center.y
        }
      };
      // console.log('pushing this distanceKeeper (based on child) to dinstanceKeepers:');
      // console.log(dk);
      distanceKeepers.push(dk);
      // console.log('distanceKeepers is now:');
      // console.log(distanceKeepers);
    });

    distanceKeepers.unshift(e);
    // console.log('distanceKeepers including firstChild:');
    // console.log(distanceKeepers[0]);
    // console.log(distanceKeepers[1]);
    // console.log(distanceKeepers);

    // CONSOLE LOG FOR TESTING
    // console.log('distanceKeepers have been defined:');
    // console.log(distanceKeepers);

    // iterate over every pair of distance keeper circles
    // in order to find the lowest valid center point for children c
    // console.log('logging DKs with forEach():');
    // distanceKeepers.forEach(dk => console.log(dk));

    distanceKeepers.forEach(c1 => {
      const indexC1 = distanceKeepers.indexOf(c1);
      // console.log(`distanceKeepers.length: ${distanceKeepers.length}`);
      // console.log(`indexC1: ${indexC1}`);
      let nextIndex;
      if (distanceKeepers.length === indexC1 + 1) {
        // console.log('inside the return if-part:');
        // console.log(`distanceKeepers.length: ${distanceKeepers.length}`);
        // console.log(distanceKeepers);
        // console.log(`indexC1: ${indexC1}`);
        // console.log('gonna skip the loop since c1 is the last element of the DKs:');
        // console.log(c1);
        return;
      } else {
        // console.log('executed loop since c1 wasnt the last element');
        nextIndex = indexC1 + 1;
      }
      // console.log('outer distanceKeepers.forEach() loop. c1 is:');
      // console.log(c1);
      // loop over all pairs
      distanceKeepers.slice(nextIndex).forEach(c2 => {
        // calculate the intersections points (there are 0, 1, or 2)
        const intersections = calcIntersections(
          {x: c1.center.x, y: c1.center.y, r: c1.r},
          {x: c2.center.x ,y: c2.center.y ,r: c2.r}
        );

        // console.log('intersections of first two distanceKeepers:');
        // console.log(intersections);

        // CONSOLE LOG FOR TESTING
        // console.log('found intersections:');
        // console.log(intersections[0]);
        // console.log(intersections[1]);

        // continue if there are no intersections
        if (!intersections) {
          return;
        }


        // check if there is a new optimal (lowest) intersection
        intersections.forEach(i => {
          // CONSOLE LOG FOR TESTING
          // console.log('there are intersections!');
          // const notLowerThanLastPlacedCenter = i.y <= lastPlacedCenter.y;
          const isLower = (newCenter.y ? i.y > newCenter.y : true)
          // console.log(`newCenter is currently: `);
          // console.log(newCenter);
          // console.log('the tested intersection is:');
          // console.log(i);
          // console.log(`isLower = ${isLower}`);
          if (isLower) {
            let isValid = valid({
                placedChildren: placedChildren,
                newIntersection: i,
                radiusChild: c.r,
                x: pc.center.x,
                y: pc.center.y,
                r: pc.r
              });
            // console.log(`isValid = ${isValid}`);
            if (isValid) {
              newCenter = i;
              // console.log('valid intersection:');
              // console.log(i);
            }
          }
          // console.log()
        }); /* end of 'intersections.forEach' */
        // console.log('set the newCenter to:');
        // console.log(newCenter);
      }); /* end of 'distanceKeepers.forEach' inner loop*/
    }); /* end of 'distanceKeepers.forEach' outer loop*/

    // set the new center
    c.bottom = pc.clientHeight - newCenter.y - c.r;
    c.style.bottom = `${c.bottom}px`;
    c.left = newCenter.x - c.r;
    c.style.left = `${c.left}px`;
    c.center = newCenter;
    // lastPlacedCenter = c.center;
    placedChildren.push(c);
  // console.log(`c.r: ${c.r}`);
  // console.log('set the parameters style.bottom and style.left of the second subcircle:');
  // console.log(`bottom: ${c.bottom}px`);
  // console.log(`left: ${c.left}px`);
  }); /* end of 'remainingChildren.forEach' */
}


function distance(p0, p1) {
  const dx = p1.x - p0.x;
  const dy = p1.y - p0.y;
  return Math.sqrt(dy ** 2 + dx ** 2);
}

function calcHypothenuse(a, b) {
  return Math.sqrt(a ** 2 + b ** 2);
}

function areDisjoint(params) {
  return params.d > (params.r0 + params.r1);
}

function containOneAnother(params) {
  return params.d < Math.abs(params.r0 - params.r1);
}

// checks if the intersection is within the boundaries of the circle
// AND if it doesn't intersect with any circle already placed
function valid(params) {
  const placedChildren = params.placedChildren;

  const childX = params.newIntersection.x;
  const childY = params.newIntersection.y;
  const childR = params.radiusChild;

  const parentX = params.x;
  const parentY = params.y;
  const parentR = params.r;

  const d = distance({x: childX, y: childY}, {x: parentX, y: parentY});
  if (d + childR > parentR + TOLERANCE_PX) {
    // child circle crosses boundaries of parent circle
    return false;
  }

  // check if new circle intersects with any circle already placed
  let result = true;
  for (let i = 0; i < placedChildren.length; i++) {
    const placed = placedChildren[i];
    if (areasOverlap(
        {x: childX, y: childY, r: childR},
        {x: placed.center.x, y: placed.center.y, r: placed.r})) {
      result = false;
      break;
    }
  }
  return result;
}

function areasOverlap(c0, c1) {
  const d = distance(
    {x: c0.x, y: c0.y},
    {x: c1.x, y: c1.y}
  );
  return d + TOLERANCE_PX < c0.r + c1.r;
}

function calcIntersections(p0, p1) {
  const x0 = p0.x;
  const y0 = p0.y;
  const r0 = p0.r;
  const x1 = p1.x;
  const y1 = p1.y;
  const r1 = p1.r;

  // dx and dy are the vertical and horizontal distances between
  // the circle centers.
  const dx = x1 - x0;
  const dy = y1 - y0;

  // Determine the straight-line distance between the centers.
  const d = calcHypothenuse(dx, dy);
  /* Check for solvability. */

  if (areDisjoint({d, r0, r1}) || containOneAnother({d, r0, r1})) {
    // no solution
    return false;
  }

  // Determine the distance from point 0 to point 2.
  const a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

  // 'point 2' is the point where the line through the circle
  // intersection points crosses the line between the circle
  // centers.
  // Determine the coordinates of point 2.
  const x2 = x0 + (dx * a/d);
  const y2 = y0 + (dy * a/d);

  /* Determine the distance from point 2 to either of the
   * intersection points.
   */
  const h = Math.sqrt((r0*r0) - (a*a));

  /* Now determine the offsets of the intersection points from
   * point 2.
   */
  const rx = -dy * (h/d);
  const ry = dx * (h/d);

  /* Determine the absolute intersection points. */
  const xi = x2 + rx;
  const xi_prime = x2 - rx;
  const yi = y2 + ry;
  const yi_prime = y2 - ry;

  return [{x: xi, y: yi}, {x: xi_prime, y: yi_prime}];
}

export { positionOrgChart };
