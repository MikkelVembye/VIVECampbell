# Pooling across (multiple) subgroups

Say that we have means and SDs at pre-test and post-test for
participants in each of two conditions, 0 and 1, and furthermore that
these summary statistics are reported separately for two different
sub-groups, \\A\\ and \\B\\. Let \\n\_{gj}\\ be the sample size for
sub-group \\g = A, B\\ in condition \\j = 0, 1\\. Let \\\bar{y}\_{gjt}\\
be the sample mean of the outcome at time \\t = 0,1\\ (where \\t = 0\\
is the pre-test and \\t = 1\\ is the post-test), and let \\s\_{gjt}\\ be
the sample standard deviation at time \\t = 0,1\\.

To recover the summary statistics for the *full* sample (pooled across
sub-groups), we can do the following:

- The total sample size in condition \\j\\ is \\ n\_{\bullet j} =
  n\_{Aj} + n\_{Bj}. \\
- The average outcome in condition \\j\\ at time \\t\\ is \\ y\_{\bullet
  jt} = \frac{n\_{Aj} \bar{y}\_{Ajt} + n\_{Bj}
  \bar{y}\_{Bjt}}{n\_{\bullet j}}. \\
- The full-sample variance in condition \\j\\ at time \\t\\ is \\
  s\_{\bullet jt}^2 = \frac{1}{n\_{\bullet j} - 1} \left\[(n\_{Aj} - 1)
  s\_{Ajt}^2 + (n\_{Bj} - 1) s\_{Bjt}^2 + \frac{n\_{Aj}
  n\_{Bj}}{n\_{\bullet j}} (\bar{y}\_{Ajt} - \bar{y}\_{Bjt})^2 \right\]
  \\

From these “rehydrated” summary statistics, one could calculate a
standardized mean difference at post-test, adjusting for pre-test
differences, by taking \\ d_p = \frac{\left(\bar{y}\_{\bullet 11} -
\bar{y}\_{\bullet 01}\right) - \left(\bar{y}\_{\bullet 10} -
\bar{y}\_{\bullet 00}\right)}{s\_{\bullet \bullet 1}} \\ where \\
s\_{\bullet \bullet 1} = \sqrt{\frac{1}{n\_{\bullet 0} + n\_{\bullet 1}}
\left\[ (n\_{\bullet 0} - 1) s\_{\bullet 01}^2 + (n\_{\bullet 1} - 1)
s\_{\bullet 11}^2\right\]}, \\ i.e., the pooled sample standard
deviation at post-test. The sampling variance of \\d_p\\ can be
approximated as \\ \text{Var}(d_p) \approx 2\left(1 -
\rho\right)\left(\frac{1}{n\_{\bullet 0}} + \frac{1}{n\_{\bullet
1}}\right) + \frac{d^2}{2\left(n\_{\bullet 0} + n\_{\bullet 1} -
2\right)}, \\ where \\\rho\\ is the correlation between the pre-test and
the post-test within each condition and each sub-group.

Alternately, one could take a slightly different approach to calculating
the numerator of the SMD, by instead calculating adjusted mean
differences across sub-groups, and then taking their weighted average
with weights corresponding to the total sample size of the sub-group.
This amounts to using a mean difference that adjusts for sub-group
differences. Denote the difference-in-differences within each subgroup
as \\ DD\_{g} = \left(\bar{y}\_{g11} - \bar{y}\_{g01}\right) -
\left(\bar{y}\_{g10} - \bar{y}\_{g00}\right). \\ Then the average
difference-in-differences is \\ DD\_{\bullet} = \frac{1}{n\_{\bullet
\bullet}}\left\[n\_{A\bullet} DD\_{A} + n\_{B\bullet} DD\_{B} \right\],
\\ where \\n\_{g\bullet} = n\_{g 0} + n\_{g 1}\\ and \\n\_{\bullet
\bullet} = n\_{A\bullet} + n\_{B\bullet} = n\_{\bullet 0} + n\_{\bullet
1}\\. This average difference-in-differences could then be used in the
numerator of the SMD, as \\ d\_{sg} = \frac{DD\_\bullet}{s\_{\bullet
\bullet 1}}. \\ The sampling variance of \\d\_{sg}\\ can be approximated
as \\ \text{Var}(d\_{sg}) \approx \frac{2\left(1 -
\rho\right)}{n\_{\bullet
\bullet}^2}\left\[\frac{n\_{A\bullet}^3}{n\_{A0} n\_{A1}} +
\frac{n\_{B\bullet}^3}{n\_{B0} n\_{B1}}\right\] +
\frac{d^2}{2\left(n\_{\bullet \bullet} - 2\right)}. \\

## Multiple sub-groups

Now suppose that we have the same data as above, but reported separately
for \\G\\ different sub-groups, indexed by \\g = 1,...,G\\. Let
\\n\_{gj}\\ be the sample size for sub-group \\g = 1,...,G\\ in
condition \\j = 0, 1\\. Let \\\bar{y}\_{gjt}\\ be the sample mean of the
outcome at time \\t = 0,1\\ (where \\t = 0\\ is the pre-test and \\t =
1\\ is the post-test), and let \\s\_{gjt}\\ be the sample standard
deviation at time \\t = 0,1\\.

To recover the summary statistics for the *full* sample (pooled across
sub-groups), we can do the following:

- The total sample size in condition \\j\\ is \\ n\_{\bullet j} =
  \sum\_{g = 1}^G n\_{gj}. \\
- The average outcome in condition \\j\\ at time \\t\\ is \\ y\_{\bullet
  jt} = \frac{1}{n\_{\bullet j}} \sum\_{g = 1}^G n\_{gj} \bar{y}\_{gjt}.
  \\
- The full-sample variance in condition \\j\\ at time \\t\\ is \\
  s\_{\bullet jt}^2 = \frac{1}{n\_{\bullet j} - 1} \sum\_{g = 1}^G
  \left\[\left(n\_{gj} - 1 \right) s\_{gjt}^2 +
  n\_{gj}\left(\bar{y}\_{gjt} - \bar{y}\_{\bullet jt}\right)^2\right\]
  \\

From these “rehydrated” summary statistics, one could calculate a
standardized mean difference at post-test, adjusting for pre-test
differences, as described above.

Alternately, one could calculate the numerator of the SMD as the
adjusted mean difference, pooled across sub-groups. The average
difference-in-differences is \\ DD\_{\bullet} = \frac{1}{n\_{\bullet
\bullet}} \sum\_{g=1}^G n\_{g \bullet} \\ DD\_{g}, \\ where
\\n\_{g\bullet} = n\_{g 0} + n\_{g 1}\\ and \\n\_{\bullet \bullet} =
\sum\_{g = 1}^G n\_{g\bullet}\\. This average difference-in-differences
could then be used in the numerator of the SMD, as \\ d\_{sg} =
\frac{DD\_\bullet}{s\_{\bullet \bullet 1}}. \\ The sampling variance of
\\d\_{sg}\\ can be approximated as \\ \text{Var}(d\_{sg}) \approx
2\left(1 - \rho\right)\left\[\sum\_{g=1}^G
\frac{n\_{g\bullet}^2}{n\_{\bullet \bullet}^2} \left(\frac{1}{n\_{g0}} +
\frac{1}{n\_{g1}}\right)\right\] + \frac{d^2}{2\left(n\_{\bullet
\bullet} - 2\right)}. \\

## INSERT EMPIRICAL EXAMPLE
