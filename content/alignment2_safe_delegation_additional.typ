#import "meta/gabri_notes.typ": *
#import "meta/note-status.typ": note-status
#show: gabri_notes.with(
  lec_num: 14,
  date: [Tue, Nov 10, 2026],
  title: "Alignment (part II)",
  instructor: [Natalie Collina],
)

// Section 3d (L14): additional results on safe delegated authorization.
// This file compiles on its own. When it is merged into the Section 3 PR:
//  - delete the recap paragraph below (Sections 3a-3c introduce the single-round model),
//  - demote the headings by one level if Section 3 is a top-level "=" heading,
//  - replace the hard-coded "Section 3c" and the TODO(merge) notes with labels,
//  - check that the sd- labels do not collide with labels chosen in Sections 3a-3c.
// Notation follows the slides: user utility u_A, reviewer utilities u_1, ..., u_n,
// baseline q^b (one round) or pi_0 (many rounds), proposal q^p.

#note-status[Draft of Section 3d (L14, additional results on safe delegation) - work in progress.]

= Safe delegation: additional results <sec-sd-more>

// TODO(merge): delete this recap once Sections 3b-3c precede it.
_Recap._ In the single-round model, reviewer $i$ approves a proposal $q^p$ when $EE_(q^p)[u_i] >= EE_(q^b)[u_i]$, and under the unanimous rule the panel is safe when $u_A = sum_i alpha_i u_i + beta$ with $alpha_i >= 0$ (Section 3c).

== From one decision to long horizons <sec-sd-mdp>

An agent that edits files or executes transactions acts repeatedly, and each action changes the state in which the next action is proposed. Consider a discounted MDP with states $y in cal(Y)$, actions $a in cal(A)$, transition probabilities $P(dot mid(|) a, y)$, discount factor $gamma in (0, 1)$, per-step utilities $u_j : cal(A) times cal(Y) -> RR$ for $j in {A, 1, ..., n}$, and a stationary baseline policy $pi_0$. Let $V^(pi_0)(u, y)$ be the expected discounted utility of following $pi_0$ from $y$, and
$
  Q^(pi_0)(u, a, y) := u(a, y) + gamma EE_(y' ~ P(dot mid(|) a, y))[V^(pi_0)(u, y')], quad
  "Adv"_j (q, y) := EE_(a ~ q)[Q^(pi_0)(u_j, a, y)] - V^(pi_0)(u_j, y).
$
Thus $"Adv"_j (q, y)$ is the change in $j$'s expected discounted utility when the first action is drawn from $q$ instead of $pi_0(dot mid(|) y)$; we write $"Adv"_j (a, y)$ when $q$ plays $a$ with probability one. At step $t$, the proposer chooses $q_t in Delta(cal(A))$ as a function of the history, reviewer $i$ approves if and only if $"Adv"_i (q_t, y_t) >= 0$ (@fig-sd-local-global a), and $a_t$ is drawn from $q_t$ if every reviewer approves and from $pi_0(dot mid(|) y_t)$ otherwise. The panel is _long-run safe_ if the user's expected discounted utility $J(u_A)$ under the resulting policy is at least $V^(pi_0)(u_A, y_0)$ for every initial state $y_0$ and every proposer.

#figure(
  image("figures/alignment2_safe_delegation_additional/local_vs_global.svg", width: 100%),
  placement: auto,
  caption: [(a) A vote at state $y_t$. Reviewer $i$ compares drawing the first action from $q_t$ and then following $pi_0$ with following $pi_0$ from the start, and approves if the first is at least as good. (b) The actual run. Each action is drawn from the proposal if every reviewer approves (orange) and from $pi_0$ otherwise (gray). The user's total gain over the baseline is the discounted sum of the user's advantages along the run.],
) <fig-sd-local-global>

Each vote thus looks one step ahead, whereas the run consists of many such steps, each proposed after the outcomes of the previous ones. The next theorem shows that controlling every single step is enough.

#theorem[Local safety is long-run safety #citep(<collina2026delegating>, [Thm.~2])][
  The panel is long-run safe if and only if every proposal $q$ that it executes at any state $y$ satisfies $"Adv"_A (q, y) >= 0$. Under the unanimous rule, this holds if and only if for every state $y$ there are weights $alpha_i (y) >= 0$ such that $"Adv"_A (q, y) >= sum_i alpha_i (y) "Adv"_i (q, y)$ for all $q in Delta(cal(A))$.
] <thm-sd-local-global>

When $pi_0(dot mid(|) y)$ assigns positive probability to every action, the inequality holds with equality: $Q^(pi_0)(u_A, dot, y) = sum_i alpha_i (y) Q^(pi_0)(u_i, dot, y) + beta(y)$. This is the single-round condition with $Q^(pi_0)$ in place of the per-step utilities, and the weights may depend on the state.

#proofsketch[
  By the performance-difference identity #citep(<kakade2002approximately>), $J(u_A) - V^(pi_0)(u_A, y_0) = EE[sum_(t >= 0) gamma^t "Adv"_A (a_t, y_t)]$ (@fig-sd-local-global b), and given the history each term has conditional mean $"Adv"_A (q_t, y_t) >= 0$ if the proposal is executed and $0$ otherwise. Conversely, a proposer that starts at $y$, proposes an executed $q$ with $"Adv"_A (q, y) < 0$, and then proposes $pi_0$ yields $J(u_A) < V^(pi_0)(u_A, y)$. The last equivalence is the single-round theorem applied at each state to $Q^(pi_0)(u_j, dot, y)$.
]

The same identity gives $J(u_A) >= V^(pi_0)(u_A, y_0) - overline(eps) \/ (1 - gamma)$ if every executed proposal has $"Adv"_A >= -overline(eps)$ #citep(<collina2026delegating>, [Cor.~4]). If $u_A = sum_i lambda_i u_i$ with constants $lambda_i >= 0$, then by linearity the condition of @thm-sd-local-global holds at every state for every $P$, $pi_0$ and proposer #citep(<collina2026delegating>, [Cor.~6]). This sufficient condition is not necessary.

#example[A conservative and an aggressive action][
  Let $cal(Y) = {"working", "failed"}$, $cal(A) = {a_0, a_1}$ and $gamma = 9 \/ 10$. In state working, the conservative action $a_0$ keeps the system working, and the aggressive action $a_1$ makes it fail with probability $rho$; in state failed, $a_0$ restores it with probability $1 \/ 2$, and $a_1$ leaves it failed. The baseline plays $a_0$ in both states, and the proposer always proposes $a_1$. Let $g(a, y)$ be the progress ($1$ for $a_0$ and $2$ for $a_1$ in state working, $0$ in state failed) and $f(y) := bb(1)[y = "failed"]$. The user has $u_A = g - 3 f$, and for every $u = c_g g - c_f f$ with $c_g, c_f >= 0$,
  $
    "Adv"(a_1, "working") = c_g - (18 rho (c_g + c_f)) / 11, quad quad "Adv"(a_1, "failed") = -(9 (c_g + c_f)) / 11.
  $
  So $a_1$ harms the user in state working if and only if $rho > 11 \/ 72$, and every reviewer below rejects it in state failed.

  _Panel I_ consists of $u_1 = g$ and $u_2 = -3 f$. Since $u_1 + u_2 = u_A$, it is long-run safe for every $rho$; in fact $u_2$ rejects $a_1$ whenever $rho > 0$, also when $rho < 11 \/ 72$ and $a_1$ would help the user. _Panel II_ consists of $u_1 = g$ and $u'_2 = g - f$, and $u_A = 3 u'_2 - 2 u_1$ has a negative coefficient. Both reviewers approve $a_1$ in state working if and only if $rho <= 11 \/ 36$, so for $11 \/ 72 < rho <= 11 \/ 36$ the panel executes a harmful action; at $rho = 1 \/ 5$, $J(u_A) = 560 \/ 73 < 10 = V^(pi_0)(u_A, "working")$. For $rho > 11 \/ 36$, Panel II is long-run safe although $u_A$ is not a nonnegative combination of its reviewers: in state working every deviation from $pi_0$ is a multiple of $a_1 - a_0$, so @thm-sd-local-global only requires some reviewer to have negative advantage whenever the user does. Finally, if the reviewers of Panel I compared $u_i (a_1, y)$ with $u_i (a_0, y)$ instead of advantages, they would approve $a_1$ in both states, and at $rho = 1 \/ 5$ the user would obtain $J(u_A) = -85 \/ 7$.
] <ex-sd-mdp>

== The converse and other voting rules <sec-sd-more-rules>

// TODO(merge): drop the first two sentences if Section 3c already proves the converse.
The "only if" direction of the single-round theorem follows from linear programming duality #citep(<collina2026delegating>, [Thm.~1]). Minimizing $EE_q [u_A] - EE_(q^b)[u_A]$ over all $q$ that every reviewer approves gives $0$ exactly when the panel is safe; the optimal dual variables of the approval constraints are then weights $lambda_i >= 0$ with $u_A - EE_(q^b)[u_A] >= sum_i lambda_i (u_i - EE_(q^b)[u_i])$ for every action, and if no such weights exist, the minimizer is a harmful proposal that every reviewer approves.

The lecture used the unanimous rule throughout. A rule that executes a proposal whenever at most $k$ reviewers object is safe if and only if every set of $n - k$ reviewers satisfies the inequality above on its own #citep(<collina2026delegating>, [Cor.~2]). Under unanimity any single reviewer can force the baseline, so if $u_A = sum_i lambda_i u_i$ with $lambda_i >= 0$, every Nash equilibrium of the game between the proposer and the reviewers gives the user at least $V^(pi_0)(u_A, y_0)$ #citep(<collina2026delegating>, [Cor.~7]). For $k >= 1$, by contrast, a single objection cannot change the outcome, and unanimous approval can be an unsafe Nash equilibrium even when every reviewer has utility $u_A$ #citep(<collina2026delegating>, [Prop.~3]). Finally, rules based on approve-or-reject votes cannot avoid the caution of Panel I in general. In the single-round model, when some feasible proposal helps the user and another harms the user, such a rule executes exactly the proposals the user weakly prefers to the baseline if and only if some reviewer is individually aligned with the user #citep(<collina2026delegating>, [Thm.~4]).

#lec_bibliography("meta/refs.bib")
