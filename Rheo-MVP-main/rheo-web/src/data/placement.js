/* ══════════════════════════════════════════════════
   PLACEMENT — a short adaptive check that sets where a learner starts
   ══════════════════════════════════════════════════

   Everyone used to begin at START_RATING (1000) regardless of experience.
   That is wrong in both directions: a true beginner (~820) is over-rated and
   gets hammered until the engine catches up, which measurement showed takes
   most of the journey; someone who already reads code is under-rated and has
   to grind through chapters of material they know.

   The design follows computerized adaptive testing, the standard used by
   placement instruments: start near the middle, and after each answer move the
   estimate toward the difficulty that would have produced it, halving the step
   each time. Six items narrow a 650–1965 range to roughly ±100, which is all
   the precision the selector needs — it only has to pick the right CHAPTER
   band, not a exact rating.

   Two things this deliberately does NOT do:
     · It is never compulsory. A learner who says "I have never coded" is
       placed at the floor without being asked to fail six questions first —
       a test you cannot pass is a bad first impression, not a measurement.
     · It does not award XP or affect streaks. It is calibration, not a lesson.
*/

import { loadSaved, saveTo } from './storage.js'
import { journeyNodes } from './core.js'
import { getExercisesForNode } from './core.js'
import { getDifficulty, expectedScore } from './adaptive.js'

const PLACEMENT_KEY = 'rheo_placement'

/** Where the ladder starts and how wide the first step is. */
const START = 1150
const FIRST_STEP = 380
export const PLACEMENT_LENGTH = 6

/** Ratings we place self-declared learners at, when they skip the test. */
export const SELF_DECLARED = {
    new:      820,   // "I have never written code"
    some:     1150,  // "I can follow simple code"
    working:  1550,  // "I write code regularly"
}

export function isPlacementDone() { return !!loadSaved(PLACEMENT_KEY, null) }
export function getPlacement() { return loadSaved(PLACEMENT_KEY, null) }

/** Record the outcome so the journey can explain where it put someone. */
export function savePlacement(rating, source) {
    const record = { rating: Math.round(rating), source, at: new Date().toDateString() }
    saveTo(PLACEMENT_KEY, record)
    return record
}

/**
 * Pick one item whose difficulty sits closest to `target`, never repeating.
 * Draws from across the whole journey so the ladder can actually reach both
 * ends of the range — a placement test confined to chapter 1 could only ever
 * report "beginner".
 */
export function pickPlacementItem(target, usedKeys, lang) {
    let best = null, bestGap = Infinity
    for (const node of journeyNodes) {
        if (node.type === 'concept' || node.type === 'chest') continue
        for (const ex of getExercisesForNode(node.id, lang)) {
            // Only self-contained multiple choice: a placement item has to be
            // answerable without the scaffolding a lesson provides. Three
            // options minimum — a two-way item is a coin flip, and six coin
            // flips do not measure anything.
            if (!Array.isArray(ex.options) || typeof ex.correct !== 'number') continue
            if (ex.options.length < 3) continue
            const key = `${node.id}:${ex._exerciseIndex}`
            if (usedKeys.has(key)) continue
            const gap = Math.abs(getDifficulty(ex, lang) - target)
            if (gap < bestGap) { bestGap = gap; best = { ex, key, difficulty: getDifficulty(ex, lang) } }
        }
    }
    return best
}

/**
 * Move the estimate after one answer. Correct pushes up, wrong pushes down,
 * and the step halves each round so the estimate settles instead of swinging.
 */
export function nextEstimate(estimate, itemDifficulty, correct, round) {
    const step = FIRST_STEP / Math.pow(2, round)
    // Weight by how surprising the answer was: getting a much harder item right
    // says more than getting an expected one right.
    const surprise = correct
        ? 1 - expectedScore(estimate, itemDifficulty)
        : expectedScore(estimate, itemDifficulty)
    const move = step * (0.5 + surprise)
    return correct ? estimate + move : estimate - move
}

export const PLACEMENT_START = START
