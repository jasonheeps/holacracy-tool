// the tolerance is needed to tackle inaccuracy due to rounding pixels
const TOLERANCE_PX = 0.01;

const positionOrgChart = () => {
  const orgchart = document.querySelector('.orgchart');
  if (!orgchart) {
    return;
  }

  // define a radius for all elements
  const elements = document.querySelectorAll('.circle-0, .subcircle, .role');
  elements.forEach(e => e.r = e.offsetWidth/2);

  // define center of gcc
  const GCC = document.querySelector('.circle-0');
  GCC.center = {
    x: GCC.offsetWidth/2,
    y: GCC.offsetHeight/2
  };

  positionChildren(GCC, Array.from(GCC.querySelectorAll(':scope > .subcircle, :scope > .role')));

  const subcircles = Array.from(document.querySelectorAll('.subcircle'));
  subcircles.forEach(c => {
    const children = Array.from(c.querySelectorAll(':scope > .subcircle, :scope > .role'));
    positionChildren(c, children);
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

function positionChildren(pc, children) {
  if (children.length === 0) {
    return;
  }

  // overwrite the old center of the parent circle such that it's
  // relative to itself (and not its parent circle anymore)
  pc.center.x = pc.clientWidth/2;
  pc.center.y = pc.clientHeight/2;

  // position the first child at the bottom of its parent circle
  const firstChild = children[0];
  firstChild.style.bottom = '0px'; /* pc.style.bottom = lowest x coordinate of pc; GCC.*/
  firstChild.style.left = `${pc.center.x - firstChild.r}px`;
  firstChild.center = {x: pc.center.x, y: pc.clientHeight - firstChild.r};

  // let lastPlacedCenter = firstChild.center;

  const placedChildren = [firstChild];
  const remainingChildren = children.slice(1);

  // find a position (center) for all remaining children
  remainingChildren.forEach(c => {
    let newCenter = {};

    // define a circle around the center of pc with distance
    // r to the border of pc (smaller than pc)
    const distanceKeepers = [{
      r: pc.r - c.r,
      center: {
        x: pc.center.x,
        y: pc.center.y
      }
    }];

    // define circles around the centers of all placed children
    // with distance r to the border of a placed child (bigger
    // than child)
    placedChildren.forEach(placed => {
      let dk = {
        r: placed.r + c.r,
        center: {
          x: placed.center.x,
          y: placed.center.y
        }
      };
      distanceKeepers.push(dk);
    });

    // iterate over every pair of distance keeper circles
    // in order to find the lowest valid center point for children c
    distanceKeepers.forEach(c1 => {
      const indexC1 = distanceKeepers.indexOf(c1);
      let nextIndex;
      if (distanceKeepers.length === indexC1 + 1) {
        return;
      }
      nextIndex = indexC1 + 1;

      // loop over all pairs
      distanceKeepers.slice(nextIndex).forEach(c2 => {
        // calculate the intersections points (there are 0, 1, or 2)
        const intersections = calcIntersections(
          {x: c1.center.x, y: c1.center.y, r: c1.r},
          {x: c2.center.x ,y: c2.center.y ,r: c2.r}
        );

        // continue with the next pair if there are no intersections
        if (!intersections) {
          return;
        }

        // check if there is a new optimal (lowest) intersection
        intersections.forEach(i => {
          const isLower = (newCenter.y ? i.y > newCenter.y : true)
          if (isLower) {
            let isValid = valid({
                placedChildren: placedChildren,
                newIntersection: i,
                radiusChild: c.r,
                x: pc.center.x,
                y: pc.center.y,
                r: pc.r
              });
            if (isValid) {
              // intersection is lower and valid
              newCenter = i;
            }
          }
        }); /* end of 'intersections.forEach' */
      }); /* end of 'distanceKeepers.forEach' inner loop*/
    }); /* end of 'distanceKeepers.forEach' outer loop*/

    // set the new center
    c.style.bottom = `${pc.clientHeight - newCenter.y - c.r}px`;
    c.style.left = `${newCenter.x - c.r}px`;
    c.center = newCenter;
    // lastPlacedCenter = c.center;
    placedChildren.push(c);
  }); /* end of 'remainingChildren.forEach' */
} /* end of 'positionChildren()' */


function distance(p0, p1) {
  const dx = p1.x - p0.x;
  const dy = p1.y - p0.y;
  return Math.sqrt(dy ** 2 + dx ** 2);
}

function calcHypothenuse(a, b) {
  return Math.sqrt(a ** 2 + b ** 2);
}

function areDisjoint(params) {
  return params.d > (params.r0 + params.r1) + TOLERANCE_PX;
}

function containOneAnother(params) {
  return params.d + TOLERANCE_PX < Math.abs(params.r0 - params.r1);
}

function areasOverlap(c0, c1) {
  const d = distance(
    {x: c0.x, y: c0.y},
    {x: c1.x, y: c1.y}
  );
  return d + TOLERANCE_PX < c0.r + c1.r;
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
