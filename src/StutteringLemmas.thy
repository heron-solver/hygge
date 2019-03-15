subsection\<open>Stuttering Lemmas\<close>

theory StutteringLemmas

imports StutteringDefs

begin

subsection {* Lemmas used to prove the invariance by stuttering *}

text \<open>A dilating function is injective.\<close>

lemma dilating_fun_injects:
  assumes "dilating_fun f r"
  shows   "inj_on f A"
using assms dilating_fun_def strict_mono_imp_inj_on by blast

text {*
  If a clock ticks at an instant in a dilated run, that instant is the image
  by the dilating function of an instant of the original run.
*}
lemma ticks_image:
  assumes "dilating_fun f r"
  and     "hamlet ((Rep_run r) n c)"
  shows   "\<exists>n\<^sub>0. f n\<^sub>0 = n"
using dilating_fun_def assms by blast

text \<open> 
  The image of the ticks in a interval by a dilating function is the interval 
  bounded by the image of the bound of the original interval.
  This is proven for all 4 kinds of intervals:  \<^verbatim>\<open>]m, n[\<close>, \<^verbatim>\<open>[m, n[\<close>, \<^verbatim>\<open>]m, n]\<close> and \<^verbatim>\<open>[m, n]\<close>.
\<close>

lemma dilating_fun_image_strict:
  assumes "dilating_fun f r"
  shows   "{k. f m < k \<and> k < f n \<and> hamlet ((Rep_run r) k c)}
            = image f {k. m < k \<and> k < n \<and> hamlet ((Rep_run r) (f k) c)}"
  (is "?IMG = image f ?SET")
proof
  { fix k assume h:"k \<in> ?IMG"
    from h obtain k\<^sub>0 where k0prop:"f k\<^sub>0 = k \<and> hamlet ((Rep_run r) (f k\<^sub>0) c)"
      using ticks_image[OF assms] by blast
    with h have "k \<in> image f ?SET" using assms dilating_fun_def strict_mono_less by blast
  } thus "?IMG \<subseteq> image f ?SET" ..
next
  { fix k assume h:"k \<in> image f ?SET"
    from h obtain k\<^sub>0 where k0prop:"k = f k\<^sub>0 \<and> k\<^sub>0 \<in> ?SET" by blast
    hence "k \<in> ?IMG" using assms by (simp add: dilating_fun_def strict_mono_less)
  } thus "image f ?SET \<subseteq> ?IMG" ..
qed

lemma dilating_fun_image_left:
  assumes "dilating_fun f r"
  shows   "{k. f m \<le> k \<and> k < f n \<and> hamlet ((Rep_run r) k c)}
          = image f {k. m \<le> k \<and> k < n \<and> hamlet ((Rep_run r) (f k) c)}"
  (is "?IMG = image f ?SET")
proof
  { fix k assume h:"k \<in> ?IMG"
    from h obtain k\<^sub>0 where k0prop:"f k\<^sub>0 = k \<and> hamlet ((Rep_run r) (f k\<^sub>0) c)"
      using ticks_image[OF assms] by blast
    with h have "k \<in> image f ?SET"
      using assms dilating_fun_def strict_mono_less strict_mono_less_eq by fastforce
  } thus "?IMG \<subseteq> image f ?SET" ..
next
  { fix k assume h:"k \<in> image f ?SET"
    from h obtain k\<^sub>0 where k0prop:"k = f k\<^sub>0 \<and> k\<^sub>0 \<in> ?SET" by blast
    hence "k \<in> ?IMG"
      using assms dilating_fun_def strict_mono_less strict_mono_less_eq by fastforce
  } thus "image f ?SET \<subseteq> ?IMG" ..
qed

lemma dilating_fun_image_right:
  assumes "dilating_fun f r"
  shows   "{k. f m < k \<and> k \<le> f n \<and> hamlet ((Rep_run r) k c)}
          = image f {k. m < k \<and> k \<le> n \<and> hamlet ((Rep_run r) (f k) c)}"
  (is "?IMG = image f ?SET")
proof
  { fix k assume h:"k \<in> ?IMG"
    from h obtain k\<^sub>0 where k0prop:"f k\<^sub>0 = k \<and> hamlet ((Rep_run r) (f k\<^sub>0) c)"
      using ticks_image[OF assms] by blast
    with h have "k \<in> image f ?SET"
      using assms dilating_fun_def strict_mono_less strict_mono_less_eq by fastforce
  } thus "?IMG \<subseteq> image f ?SET" ..
next
  { fix k assume h:"k \<in> image f ?SET"
    from h obtain k\<^sub>0 where k0prop:"k = f k\<^sub>0 \<and> k\<^sub>0 \<in> ?SET" by blast
    hence "k \<in> ?IMG"
      using assms dilating_fun_def strict_mono_less strict_mono_less_eq by fastforce
  } thus "image f ?SET \<subseteq> ?IMG" ..
qed

lemma dilating_fun_image:
  assumes "dilating_fun f r"
  shows   "{k. f m \<le> k \<and> k \<le> f n \<and> hamlet ((Rep_run r) k c)}
          = image f {k. m \<le> k \<and> k \<le> n \<and> hamlet ((Rep_run r) (f k) c)}"
  (is "?IMG = image f ?SET")
proof
  { fix k assume h:"k \<in> ?IMG"
    from h obtain k\<^sub>0 where k0prop:"f k\<^sub>0 = k \<and> hamlet ((Rep_run r) (f k\<^sub>0) c)"
      using ticks_image[OF assms] by blast
    with h have "k \<in> image f ?SET"
      using assms dilating_fun_def strict_mono_less_eq by blast
  } thus "?IMG \<subseteq> image f ?SET" ..
next
  { fix k assume h:"k \<in> image f ?SET"
    from h obtain k\<^sub>0 where k0prop:"k = f k\<^sub>0 \<and> k\<^sub>0 \<in> ?SET" by blast
    hence "k \<in> ?IMG" using assms by (simp add: dilating_fun_def strict_mono_less_eq)
  } thus "image f ?SET \<subseteq> ?IMG" ..
qed

text {*
  On any clock, the number of ticks in an interval is preserved
  by a dilating function.
*}
lemma ticks_as_often_strict:
  assumes "dilating_fun f r"
  shows   "card {p. n < p \<and> p < m \<and> hamlet ((Rep_run r) (f p) c)}
          = card {p. f n < p \<and> p < f m \<and> hamlet ((Rep_run r) p c)}"
    (is "card ?SET = card ?IMG")
proof -
  from dilating_fun_injects[OF assms] have "inj_on f ?SET" .
  moreover have "finite ?SET" by simp
  from inj_on_iff_eq_card[OF this] calculation have "card (image f ?SET) = card ?SET" by blast
  moreover from dilating_fun_image_strict[OF assms] have "?IMG = image f ?SET" .
  ultimately show ?thesis by auto
qed

lemma ticks_as_often_left:
  assumes "dilating_fun f r"
  shows   "card {p. n \<le> p \<and> p < m \<and> hamlet ((Rep_run r) (f p) c)}
          = card {p. f n \<le> p \<and> p < f m \<and> hamlet ((Rep_run r) p c)}"
    (is "card ?SET = card ?IMG")
proof -
  from dilating_fun_injects[OF assms] have "inj_on f ?SET" .
  moreover have "finite ?SET" by simp
  from inj_on_iff_eq_card[OF this] calculation have "card (image f ?SET) = card ?SET" by blast
  moreover from dilating_fun_image_left[OF assms] have "?IMG = image f ?SET" .
  ultimately show ?thesis by auto
qed

lemma ticks_as_often_right:
  assumes "dilating_fun f r"
  shows   "card {p. n < p \<and> p \<le> m \<and> hamlet ((Rep_run r) (f p) c)}
          = card {p. f n < p \<and> p \<le> f m \<and> hamlet ((Rep_run r) p c)}"
    (is "card ?SET = card ?IMG")
proof -
  from dilating_fun_injects[OF assms] have "inj_on f ?SET" .
  moreover have "finite ?SET" by simp
  from inj_on_iff_eq_card[OF this] calculation have "card (image f ?SET) = card ?SET" by blast
  moreover from dilating_fun_image_right[OF assms] have "?IMG = image f ?SET" .
  ultimately show ?thesis by auto
qed

lemma ticks_as_often:
  assumes "dilating_fun f r"
  shows   "card {p. n \<le> p \<and> p \<le> m \<and> hamlet ((Rep_run r) (f p) c)}
          = card {p. f n \<le> p \<and> p \<le> f m \<and> hamlet ((Rep_run r) p c)}"
    (is "card ?SET = card ?IMG")
proof -
  from dilating_fun_injects[OF assms] have "inj_on f ?SET" .
  moreover have "finite ?SET" by simp
  from inj_on_iff_eq_card[OF this] calculation have "card (image f ?SET) = card ?SET" by blast
  moreover from dilating_fun_image[OF assms] have "?IMG = image f ?SET" .
  ultimately show ?thesis by auto
qed

lemma dilating_injects:
  assumes "dilating f sub r"
  shows   "inj_on f A"
using assms by (simp add: dilating_def dilating_fun_def strict_mono_imp_inj_on)

text {*
  If there is a tick at instant n in a dilated run, n is necessarily the image
  of some instant in the subrun.
*}
lemma ticks_image_sub:
  assumes "dilating f sub r"
  and     "hamlet ((Rep_run r) n c)"
  shows   "\<exists>n\<^sub>0. f n\<^sub>0 = n"
using assms dilating_def ticks_image by metis

lemma ticks_image_sub':
  assumes "dilating f sub r"
  and     "\<exists>c. hamlet ((Rep_run r) n c)"
  shows   "\<exists>n\<^sub>0. f n\<^sub>0 = n"
using assms dilating_def dilating_fun_def by metis

text \<open>Time is preserved by dilation when ticks occur.\<close>

lemma ticks_tag_image:
  assumes "dilating f sub r"
  and     "\<exists>c. hamlet ((Rep_run r) k c)"
  and     "time ((Rep_run r) k c) = \<tau>"
  shows   "\<exists>k\<^sub>0. f k\<^sub>0 = k \<and> time ((Rep_run sub) k\<^sub>0 c) = \<tau>"
proof -
  from ticks_image_sub'[OF assms(1,2)] have "\<exists>k\<^sub>0. f k\<^sub>0 = k" .
  from this obtain k\<^sub>0 where "f k\<^sub>0 = k" by blast
  moreover with assms(1,3) have "time ((Rep_run sub) k\<^sub>0 c) = \<tau>" by (simp add: dilating_def) 
  ultimately show ?thesis by blast
qed

text \<open>TESL operators are preserved by dilation.\<close>

lemma ticks_sub:
  assumes "dilating f sub r"
  shows   "hamlet ((Rep_run sub) n a) = hamlet ((Rep_run r) (f n) a)"
using assms by (simp add: dilating_def)

lemma no_tick_sub:
  assumes "dilating f sub r"
  shows   "(\<nexists>n\<^sub>0. f n\<^sub>0 = n) \<longrightarrow> \<not>hamlet ((Rep_run r) n a)"
using assms dilating_def dilating_fun_def by blast

text \<open>Lifting a total function to a partial function on an option domain.\<close>

definition opt_lift::"('a \<Rightarrow> 'a) \<Rightarrow> ('a option \<Rightarrow> 'a option)"
where
  "opt_lift f \<equiv> \<lambda>x. case x of None \<Rightarrow> None | Some y \<Rightarrow> Some (f y)"

text {*
  The set of instants when a clock ticks in a dilated run is the image by the dilation function
  of the set of instants when it ticks in the subrun.
*}
lemma tick_set_sub:
  assumes "dilating f sub r"
  shows   "{k. hamlet ((Rep_run r) k c)} = image f {k. hamlet ((Rep_run sub) k c)}"
    (is "?R = image f ?S")
proof
  { fix k assume h:"k \<in> ?R"
    with no_tick_sub[OF assms] have "\<exists>k\<^sub>0. f k\<^sub>0 = k" by blast
    from this obtain k\<^sub>0 where k0prop:"f k\<^sub>0 = k" by blast
    with ticks_sub[OF assms] h have "hamlet ((Rep_run sub) k\<^sub>0 c)" by blast
    with k0prop have "k \<in> image f ?S" by blast
  }
  thus "?R \<subseteq> image f ?S" by blast
next
  { fix k assume h:"k \<in> image f ?S"
    from this obtain k\<^sub>0 where "f k\<^sub>0 = k \<and> hamlet ((Rep_run sub) k\<^sub>0 c)" by blast
    with assms have "k \<in> ?R" using ticks_sub by blast 
  }
  thus "image f ?S \<subseteq> ?R" by blast
qed

text {*
  Strictly monotonous functions preserve the least element.
*}
lemma Least_strict_mono:
  assumes "strict_mono f"
  and     "\<exists>x \<in> S. \<forall>y \<in> S. x \<le> y"
  shows   "(LEAST y. y \<in> f ` S) = f (LEAST x. x \<in> S)"
using Least_mono[OF strict_mono_mono, OF assms] .

text {*
  A non empty set of @{typ nat}s has a least element.
*}
lemma Least_nat_ex:
  "(n::nat) \<in> S \<Longrightarrow> \<exists>x \<in> S. (\<forall>y \<in> S. x \<le> y)"
by (induction n rule: nat_less_induct, insert not_le_imp_less, blast)

text {*
  The first instant when a clock ticks in a dilated run is the image by the dilation
  function of the first instant when it ticks in the subrun.
*}
lemma Least_sub:
  assumes "dilating f sub r"
  and     "\<exists>k::nat. hamlet ((Rep_run sub) k c)"
  shows   "(LEAST k. k \<in> {t. hamlet ((Rep_run r) t c)}) = f (LEAST k. k \<in> {t. hamlet ((Rep_run sub) t c)})"
          (is "(LEAST k. k \<in> ?R) = f (LEAST k. k \<in> ?S)")
proof -
  from assms(2) have "\<exists>x. x \<in> ?S" by simp
  hence least:"\<exists>x \<in> ?S. \<forall>y \<in> ?S. x \<le> y"
    using Least_nat_ex ..
  from assms(1) have "strict_mono f" by (simp add: dilating_def dilating_fun_def)
  from Least_strict_mono[OF this least] have
    "(LEAST y. y \<in> f ` ?S)  = f (LEAST x. x \<in> ?S)" .
  with tick_set_sub[OF assms(1), of "c"] show ?thesis by auto
qed

text {*
  If a clock ticks in a run, it ticks in the subrun.
*}
lemma ticks_imp_ticks_sub:
  assumes "dilating f sub r"
  and     "\<exists>k. hamlet ((Rep_run r) k c)"
  shows   "\<exists>k\<^sub>0. hamlet ((Rep_run sub) k\<^sub>0 c)"
proof -
  from assms(2) obtain k where "hamlet ((Rep_run r) k c)" by blast
  with ticks_image_sub[OF assms(1)] ticks_sub[OF assms(1)] show ?thesis by blast
qed

text {*
  Stronger version: it ticks in the subrun and we know when.
*}
lemma ticks_imp_ticks_subk:
  assumes "dilating f sub r"
  and     "hamlet ((Rep_run r) k c)"
  shows   "\<exists>k\<^sub>0. f k\<^sub>0 = k \<and> hamlet ((Rep_run sub) k\<^sub>0 c)"
proof -
  from no_tick_sub[OF assms(1)] assms(2) have "\<exists>k\<^sub>0. f k\<^sub>0 = k" by blast
  from this obtain k\<^sub>0 where "f k\<^sub>0 = k" by blast
  moreover with ticks_sub[OF assms(1)] assms(2) have "hamlet ((Rep_run sub) k\<^sub>0 c)" by blast
  ultimately show ?thesis by blast
qed

text {*
  A dilating function preserves the tick count on an interval for any clock.
*}
lemma dilated_ticks_strict:
  assumes "dilating f sub r"
  shows   "{i. f m < i \<and> i < f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. m < i \<and> i < n \<and> hamlet ((Rep_run sub) i c)}"
    (is "?RUN = image f ?SUB")
proof
  { fix i assume h:"i \<in> ?SUB"
    hence "m < i \<and> i < n" by simp
    hence "f m < f i \<and> f i < (f n)" using assms
      by (simp add: dilating_def dilating_fun_def strict_monoD strict_mono_less_eq)
    moreover from h have "hamlet ((Rep_run sub) i c)" by simp
    hence "hamlet ((Rep_run r) (f i) c)" using ticks_sub[OF assms] by blast
    ultimately have "f i \<in> ?RUN" by simp
  } thus "image f ?SUB \<subseteq> ?RUN" by blast
next
  { fix i assume h:"i \<in> ?RUN"
    hence "hamlet ((Rep_run r) i c)" by simp
    from ticks_imp_ticks_subk[OF assms this]
      obtain i\<^sub>0 where i0prop:"f i\<^sub>0 = i \<and> hamlet ((Rep_run sub) i\<^sub>0 c)" by blast
    with h have "f m < f i\<^sub>0 \<and> f i\<^sub>0 < f n" by simp
    moreover have "strict_mono f" using assms dilating_def dilating_fun_def by blast
    ultimately have "m < i\<^sub>0 \<and> i\<^sub>0 < n" using strict_mono_less strict_mono_less_eq by blast
    with i0prop have "\<exists>i\<^sub>0. f i\<^sub>0 = i \<and> i\<^sub>0 \<in> ?SUB" by blast
  } thus "?RUN \<subseteq> image f ?SUB" by blast
qed

lemma dilated_ticks_left:
  assumes "dilating f sub r"
  shows   "{i. f m \<le> i \<and> i < f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. m \<le> i \<and> i < n \<and> hamlet ((Rep_run sub) i c)}"
    (is "?RUN = image f ?SUB")
proof
  { fix i assume h:"i \<in> ?SUB"
    hence "m \<le> i \<and> i < n" by simp
    hence "f m \<le> f i \<and> f i < (f n)" using assms
      by (simp add: dilating_def dilating_fun_def strict_monoD strict_mono_less_eq)
    moreover from h have "hamlet ((Rep_run sub) i c)" by simp
    hence "hamlet ((Rep_run r) (f i) c)" using ticks_sub[OF assms] by blast
    ultimately have "f i \<in> ?RUN" by simp
  } thus "image f ?SUB \<subseteq> ?RUN" by blast
next
  { fix i assume h:"i \<in> ?RUN"
    hence "hamlet ((Rep_run r) i c)" by simp
    from ticks_imp_ticks_subk[OF assms this]
      obtain i\<^sub>0 where i0prop:"f i\<^sub>0 = i \<and> hamlet ((Rep_run sub) i\<^sub>0 c)" by blast
    with h have "f m \<le> f i\<^sub>0 \<and> f i\<^sub>0 < f n" by simp
    moreover have "strict_mono f" using assms dilating_def dilating_fun_def by blast
    ultimately have "m \<le> i\<^sub>0 \<and> i\<^sub>0 < n" using strict_mono_less strict_mono_less_eq by blast
    with i0prop have "\<exists>i\<^sub>0. f i\<^sub>0 = i \<and> i\<^sub>0 \<in> ?SUB" by blast
  } thus "?RUN \<subseteq> image f ?SUB" by blast
qed

lemma dilated_ticks_right:
  assumes "dilating f sub r"
  shows   "{i. f m < i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. m < i \<and> i \<le> n \<and> hamlet ((Rep_run sub) i c)}"
    (is "?RUN = image f ?SUB")
proof
  { fix i  assume h:"i \<in> ?SUB"
    hence "m < i \<and> i \<le> n" by simp
    hence "f m < f i \<and> f i \<le> (f n)" using assms
      by (simp add: dilating_def dilating_fun_def strict_monoD strict_mono_less_eq)
    moreover from h have "hamlet ((Rep_run sub) i c)" by simp
    hence "hamlet ((Rep_run r) (f i) c)" using ticks_sub[OF assms] by blast
    ultimately have "f i \<in> ?RUN" by simp
  } thus "image f ?SUB \<subseteq> ?RUN" by blast
next
  { fix i assume h:"i \<in> ?RUN"
    hence "hamlet ((Rep_run r) i c)" by simp
    from ticks_imp_ticks_subk[OF assms this]
      obtain i\<^sub>0 where i0prop:"f i\<^sub>0 = i \<and> hamlet ((Rep_run sub) i\<^sub>0 c)" by blast
    with h have "f m < f i\<^sub>0 \<and> f i\<^sub>0 \<le> f n" by simp
    moreover have "strict_mono f" using assms dilating_def dilating_fun_def by blast
    ultimately have "m < i\<^sub>0 \<and> i\<^sub>0 \<le> n" using strict_mono_less strict_mono_less_eq by blast
    with i0prop have "\<exists>i\<^sub>0. f i\<^sub>0 = i \<and> i\<^sub>0 \<in> ?SUB" by blast
  } thus "?RUN \<subseteq> image f ?SUB" by blast
qed

lemma dilated_ticks:
  assumes "dilating f sub r"
  shows   "{i. f m \<le> i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. m \<le> i \<and> i \<le> n \<and> hamlet ((Rep_run sub) i c)}"
    (is "?RUN = image f ?SUB")
proof
  { fix i assume h:"i \<in> ?SUB"
    hence "m \<le> i \<and> i \<le> n" by simp
    hence "f m \<le> f i \<and> f i \<le> (f n)"
      using assms by (simp add: dilating_def dilating_fun_def strict_mono_less_eq)
    moreover from h have "hamlet ((Rep_run sub) i c)" by simp
    hence "hamlet ((Rep_run r) (f i) c)" using ticks_sub[OF assms] by blast
    ultimately have "f i \<in>?RUN" by simp
  } thus "image f ?SUB \<subseteq> ?RUN" by blast
next
  { fix i assume h:"i \<in> ?RUN"
    hence "hamlet ((Rep_run r) i c)" by simp
    from ticks_imp_ticks_subk[OF assms this]
      obtain i\<^sub>0 where i0prop:"f i\<^sub>0 = i \<and> hamlet ((Rep_run sub) i\<^sub>0 c)" by blast
    with h have "f m \<le> f i\<^sub>0 \<and> f i\<^sub>0 \<le> f n" by simp
    moreover have "strict_mono f" using assms dilating_def dilating_fun_def by blast
    ultimately have "m \<le> i\<^sub>0 \<and> i\<^sub>0 \<le> n" using strict_mono_less_eq by blast
    with i0prop have "\<exists>i\<^sub>0. f i\<^sub>0 = i \<and> i\<^sub>0 \<in> ?SUB" by blast
  } thus "?RUN \<subseteq> image f ?SUB" by blast
qed


text \<open>No tick can occur in a dilated run before the image of 0 by the dilation function. \<close>

lemma empty_dilated_prefix:
  assumes "dilating f sub r"
  and     "n < f 0"
shows   "\<not> hamlet ((Rep_run r) n c)"
proof - (* This one is easy with the new definition of a dilating function. *)
  from assms have False by (simp add: dilating_def dilating_fun_def)
  thus ?thesis ..
qed

corollary empty_dilated_prefix':
  assumes "dilating f sub r"
  shows   "{i. f 0 \<le> i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)} = {i. i \<le> f n \<and> hamlet ((Rep_run r) i c)}"
proof -
  from assms have "strict_mono f" by (simp add: dilating_def dilating_fun_def)
  hence "f 0 \<le> f n" unfolding strict_mono_def by (simp add: less_mono_imp_le_mono)
  hence "\<forall>i. i \<le> f n = (i < f 0) \<or> (f 0 \<le> i \<and> i \<le> f n)" by auto
  hence "{i. i \<le> f n \<and> hamlet ((Rep_run r) i c)}
        = {i. i < f 0 \<and> hamlet ((Rep_run r) i c)} \<union> {i. f 0 \<le> i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)}"
    by auto
  also have "... = {i. f 0 \<le> i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)}"
     using empty_dilated_prefix[OF assms] by blast
  finally show ?thesis by simp
qed

corollary dilated_prefix:
  assumes "dilating f sub r"
  shows   "{i. i \<le> f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. i \<le> n \<and> hamlet ((Rep_run sub) i c)}"
proof -
  have "{i. 0 \<le> i \<and> i \<le> f n \<and> hamlet ((Rep_run r) i c)}
        = image f {i. 0 \<le> i \<and> i \<le> n \<and> hamlet ((Rep_run sub) i c)}"
    using dilated_ticks[OF assms] empty_dilated_prefix'[OF assms] by blast
  thus ?thesis by simp
qed

corollary dilated_strict_prefix:
  assumes "dilating f sub r"
  shows   "{i. i < f n \<and> hamlet ((Rep_run r) i c)}
          = image f {i. i < n \<and> hamlet ((Rep_run sub) i c)}"
proof -
  from assms have "dilating_fun f r" unfolding dilating_def by simp
  from dilating_fun_image_left[OF this, of "0" "n" "c"]
  have "{i. f 0 \<le> i \<and> i < f n \<and> hamlet ((Rep_run r) i c)}
        = image f {i. 0 \<le> i \<and> i < n \<and> hamlet ((Rep_run r) (f i) c)}" .
  also have "... = image f {i. 0 \<le> i \<and> i < n \<and> hamlet ((Rep_run sub) i c)}"
    using assms dilating_def by blast
  finally show ?thesis
    by (metis (mono_tags, lifting) Collect_cong assms empty_dilated_prefix le0 not_le_imp_less)
qed

text\<open>A singleton of @{typ nat} can be defined with a weaker property.\<close> 
lemma nat_sing_prop:
  "{i::nat. i = k \<and> P(i)} = {i::nat. i = k \<and> P(k)}"
by auto

text \<open>The set definition and the function definition of @{const tick_count} are equivalent.\<close>
lemma tick_count_is_fun[code]:"tick_count r c n = run_tick_count r c n"
proof (induction n)
  case 0
    have "tick_count r c 0 = card {i. i \<le> 0 \<and> hamlet ((Rep_run r) i c)}"
      by (simp add: tick_count_def)
    also have "... = card {i::nat. i = 0 \<and> hamlet ((Rep_run r) 0 c)}"
      using le_zero_eq nat_sing_prop[of "0" "\<lambda>i. hamlet ((Rep_run r) i c)"] by simp
    also have "... = (if hamlet ((Rep_run r) 0 c) then 1 else 0)" by simp
    also have "... = run_tick_count r c 0" by simp
    finally show ?case .
next
  case (Suc k)
    show ?case
    proof (cases "hamlet ((Rep_run r) (Suc k) c)")
      case True
        hence "{i. i \<le> Suc k \<and> hamlet ((Rep_run r) i c)} = insert (Suc k) {i. i \<le> k \<and> hamlet ((Rep_run r) i c)}"
          by auto
        hence "tick_count r c (Suc k) = Suc (tick_count r c k)"
          by (simp add: tick_count_def)
        with Suc.IH have "tick_count r c (Suc k) = Suc (run_tick_count r c k)" by simp
        thus ?thesis by (simp add: True)
    next
      case False
        hence "{i. i \<le> Suc k \<and> hamlet ((Rep_run r) i c)} = {i. i \<le> k \<and> hamlet ((Rep_run r) i c)}"
          using le_Suc_eq by auto
        hence "tick_count r c (Suc k) = tick_count r c k" by (simp add: tick_count_def)
        thus ?thesis using Suc.IH by (simp add: False)
    qed
qed

text\<open>The set definition and the function definition of @{const tick_count_strict}  are equivalent.\<close> 
lemma tick_count_strict_suc:"tick_count_strict r c (Suc n) = tick_count r c n"
  unfolding tick_count_def tick_count_strict_def using less_Suc_eq_le by auto

lemma tick_count_strict_is_fun[code]:"tick_count_strict r c n = run_tick_count_strictly r c n"
proof (cases "n = 0")
  case True
    hence "tick_count_strict r c n = 0" unfolding tick_count_strict_def by simp
    also have "... = run_tick_count_strictly r c 0" using run_tick_count_strictly.simps(1)[symmetric] .
    finally show ?thesis using True by simp
next
  case False
  from not0_implies_Suc[OF this] obtain m where *:"n = Suc m" by blast
  hence "tick_count_strict r c n = tick_count r c m" using tick_count_strict_suc by simp
  also have "... = run_tick_count r c m" using tick_count_is_fun[of "r" "c" "m"] .
  also have "... = run_tick_count_strictly r c (Suc m)" using run_tick_count_strictly.simps(2)[symmetric] .
  finally show ?thesis using * by simp
qed

lemma strictly_precedes_alt_def1:
  "{ \<rho>. \<forall>n::nat. (run_tick_count \<rho> K\<^sub>2 n) \<le> (run_tick_count_strictly \<rho> K\<^sub>1 n) }
 = { \<rho>. \<forall>n::nat. (run_tick_count_strictly \<rho> K\<^sub>2 (Suc n)) \<le> (run_tick_count_strictly \<rho> K\<^sub>1 n) }"
  using tick_count_is_fun tick_count_strict_suc tick_count_strict_is_fun by metis

lemma strictly_precedes_alt_def2:
  "{ \<rho>. \<forall>n::nat. (run_tick_count \<rho> K\<^sub>2 n) \<le> (run_tick_count_strictly \<rho> K\<^sub>1 n) }
 = { \<rho>. (\<not>hamlet ((Rep_run \<rho>) 0 K\<^sub>2)) \<and> (\<forall>n::nat. (run_tick_count \<rho> K\<^sub>2 (Suc n)) \<le> (run_tick_count \<rho> K\<^sub>1 n)) }"
  (is "?P = ?P'")
proof
  { fix r::"'a run"
    assume "r \<in> ?P"
    hence "\<forall>n::nat. (run_tick_count r K\<^sub>2 n) \<le> (run_tick_count_strictly r K\<^sub>1 n)" by simp
    hence 1:"\<forall>n::nat. (tick_count r K\<^sub>2 n) \<le> (tick_count_strict r K\<^sub>1 n)"
      using tick_count_is_fun[symmetric, of r] tick_count_strict_is_fun[symmetric, of r] by simp
    hence "\<forall>n::nat. (tick_count_strict r K\<^sub>2 (Suc n)) \<le> (tick_count_strict r K\<^sub>1 n)"
      using tick_count_strict_suc[symmetric, of "r" "K\<^sub>2"] by simp
    hence "\<forall>n::nat. (tick_count_strict r K\<^sub>2 (Suc (Suc n))) \<le> (tick_count_strict r K\<^sub>1 (Suc n))" by simp
    hence "\<forall>n::nat. (tick_count r K\<^sub>2 (Suc n)) \<le> (tick_count r K\<^sub>1 n)"
      using tick_count_strict_suc[symmetric, of "r"] by simp
    hence *:"\<forall>n::nat. (run_tick_count r K\<^sub>2 (Suc n)) \<le> (run_tick_count r K\<^sub>1 n)"
      by (simp add: tick_count_is_fun)
    have "tick_count_strict r K\<^sub>1 0 = 0" unfolding tick_count_strict_def by simp
    with 1 have "tick_count r K\<^sub>2 0 = 0" by (metis le_zero_eq)
    hence "\<not>hamlet ((Rep_run r) 0 K\<^sub>2)" unfolding tick_count_def by auto
    with * have "r \<in> ?P'" by simp
  } thus "?P \<subseteq> ?P'" ..
  { fix r::"'a run"
    assume h:"r \<in> ?P'"
    hence "\<forall>n::nat. (run_tick_count r K\<^sub>2 (Suc n)) \<le> (run_tick_count r K\<^sub>1 n)" by simp
    hence "\<forall>n::nat. (tick_count r K\<^sub>2 (Suc n)) \<le> (tick_count r K\<^sub>1 n)"
      using tick_count_is_fun[symmetric, of "r"] by metis
    hence "\<forall>n::nat. (tick_count r K\<^sub>2 (Suc n)) \<le> (tick_count_strict r K\<^sub>1 (Suc n))"
      using tick_count_strict_suc[symmetric, of "r" "K\<^sub>1"] by simp
    hence *:"\<forall>n. n > 0 \<longrightarrow> (tick_count r K\<^sub>2 n) \<le> (tick_count_strict r K\<^sub>1 n)"
      using gr0_implies_Suc by blast
    have "tick_count_strict r K\<^sub>1 0 = 0" unfolding tick_count_strict_def by simp
    moreover from h have "\<not>hamlet ((Rep_run r) 0 K\<^sub>2)" by simp
    hence "tick_count r K\<^sub>2 0 = 0" unfolding tick_count_def by auto
    ultimately have "tick_count r K\<^sub>2 0 \<le> tick_count_strict r K\<^sub>1 0" by simp
    with * have "\<forall>n. (tick_count r K\<^sub>2 n) \<le> (tick_count_strict r K\<^sub>1 n)" by (metis gr0I)
    hence "\<forall>n. (run_tick_count r K\<^sub>2 n) \<le> (run_tick_count_strictly r K\<^sub>1 n)"
      using tick_count_is_fun tick_count_strict_is_fun by metis
    hence "r \<in> ?P" ..
  } thus "?P' \<subseteq> ?P" ..
qed

lemma run_tick_count_suc:
  "run_tick_count r c (Suc n) = (if hamlet ((Rep_run r) (Suc n) c)
                                 then Suc (run_tick_count r c n)
                                 else run_tick_count r c n)"
by simp

corollary tick_count_suc:
  "tick_count r c (Suc n) = (if hamlet ((Rep_run r) (Suc n) c)
                             then Suc (tick_count r c n)
                             else tick_count r c n)"
by (simp add: tick_count_is_fun)

lemma card_suc:"card {i. i \<le> (Suc n) \<and> P i} = card {i. i \<le> n \<and> P i} + card {i. i = (Suc n) \<and> P i}"
proof -
  have "{i. i \<le> n \<and> P i} \<inter> {i. i = (Suc n) \<and> P i} = {}" by auto
  moreover have "{i. i \<le> n \<and> P i} \<union> {i. i = (Suc n) \<and> P i} = {i. i \<le> (Suc n) \<and> P i}" by auto
  moreover have "finite {i. i \<le> n \<and> P i}" by simp
  moreover have "finite {i. i = (Suc n) \<and> P i}" by simp
  ultimately show ?thesis using card_Un_disjoint[of "{i. i \<le> n \<and> P i}" "{i. i = Suc n \<and> P i}"] by simp
qed

lemma card_le_leq:
  assumes "m < n"
    shows "card {i::nat. m < i \<and> i \<le> n \<and> P i} = card {i. m < i \<and> i < n \<and> P i} + card {i. i = n \<and> P i}"
proof -
  have "{i::nat. m < i \<and> i < n \<and> P i} \<inter> {i. i = n \<and> P i} = {}" by auto
  moreover with assms have "{i::nat. m < i \<and> i < n \<and> P i} \<union> {i. i = n \<and> P i} = {i. m < i \<and> i \<le> n \<and> P i}" by auto
  moreover have "finite {i. m < i \<and> i < n \<and> P i}" by simp
  moreover have "finite {i. i = n \<and> P i}" by simp
  ultimately show ?thesis using card_Un_disjoint[of "{i. m < i \<and> i < n \<and> P i}" "{i. i = n \<and> P i}"] by simp
qed

lemma card_le_leq_0:"card {i::nat. i \<le> n \<and> P i} = card {i. i < n \<and> P i} + card {i. i = n \<and> P i}"
proof -
  have "{i::nat. i < n \<and> P i} \<inter> {i. i = n \<and> P i} = {}" by auto
  moreover have "{i. i < n \<and> P i} \<union> {i. i = n \<and> P i} = {i. i \<le> n \<and> P i}" by auto
  moreover have "finite {i. i < n \<and> P i}" by simp
  moreover have "finite {i. i = n \<and> P i}" by simp
  ultimately show ?thesis using card_Un_disjoint[of "{i. i < n \<and> P i}" "{i. i = n \<and> P i}"] by simp
qed

lemma card_mnm:
  assumes "m < n"
    shows "card {i::nat. i < n \<and> P i} = card {i. i \<le> m \<and> P i} + card {i. m < i \<and> i < n \<and> P i}"
proof -
  have 1:"{i::nat. i \<le> m \<and> P i} \<inter> {i. m < i \<and> i < n \<and> P i} = {}" by auto
  from assms have "\<forall>i::nat. i < n = (i \<le> m) \<or> (m < i \<and> i < n)"  using less_trans by auto
  hence 2:
    "{i::nat. i < n \<and> P i} = {i. i \<le> m \<and> P i} \<union> {i. m < i \<and> i < n \<and> P i}" by blast
  have 3:"finite {i. i \<le> m \<and> P i}" by simp
  have 4:"finite {i. m < i \<and> i < n \<and> P i}" by simp
  from card_Un_disjoint[OF 3 4 1] 2 show ?thesis by simp
qed


lemma nat_interval_union:
  assumes "m \<le> n"
    shows "{i::nat. i \<le> n \<and> P i} = {i::nat. i \<le> m \<and> P i} \<union> {i::nat. m < i \<and> i \<le> n \<and> P i}"
using assms le_cases nat_less_le by auto

lemma tick_count_fsuc:
  assumes "dilating f sub r"
  shows "tick_count r c (f (Suc n)) = tick_count r c (f n) + card {k. k = f (Suc n) \<and> hamlet ((Rep_run r) k c)}"
proof -
  from assms have *:"\<forall>k. n < k \<and> k < (Suc n) \<longrightarrow> \<not>hamlet ((Rep_run r) k c)"
    using dilating_def dilating_fun_def by linarith
  have 1:"finite {k. k \<le> f n \<and> hamlet ((Rep_run r) k c)}" by simp
  have 2:"finite {k. f n < k \<and> k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}" by simp
  have 3:"{k. k \<le> f n \<and> hamlet ((Rep_run r) k c)} \<inter> {k. f n < k \<and> k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)} = {}"
    using assms dilating_def dilating_fun_def by auto
  have "strict_mono f" using assms dilating_def dilating_fun_def by blast
  hence m:"f n < f (Suc n)" by (simp add: strict_monoD)
  hence m':"f n \<le> f (Suc n)" by simp
  have 4:"{k. k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}
          = {k. k \<le> f n \<and> hamlet ((Rep_run r) k c)} \<union> {k. f n < k \<and> k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}"
    using nat_interval_union[OF m'] . 
  have 5:"\<forall>k. (f n) < k \<and> k < f (Suc n) \<longrightarrow> \<not>hamlet ((Rep_run r) k c)"
    using * dilating_def dilating_fun_def by (metis Suc_le_eq assms leD strict_mono_less)
  have "tick_count r c (f (Suc n)) = card {k. k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}" using tick_count_def .
  also have "... = card {k. k \<le> f n \<and> hamlet ((Rep_run r) k c)}
                 + card {k. f n < k \<and> k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}"
    using card_Un_disjoint[OF 1 2 3] 4 by presburger
  also have "... = tick_count r c (f n)
                + card {k. f n < k \<and> k \<le> f (Suc n) \<and> hamlet ((Rep_run r) k c)}"
    using tick_count_def[of "r" "c" "f n"] by simp
  also have "... = tick_count r c (f n)
                  + card {k. k = f (Suc n) \<and> hamlet ((Rep_run r) k c)}"
    using 5 m by (metis order_le_less)
  finally show ?thesis .
qed

lemma card_sing_prop:"card {i. i = n \<and> P i} = (if P n then 1 else 0)"
  by (smt card_empty empty_Collect_eq is_singletonI' is_singleton_altdef mem_Collect_eq)

corollary tick_count_f_suc:
  assumes "dilating f sub r"
    shows "tick_count r c (f (Suc n)) = tick_count r c (f n) + (if hamlet ((Rep_run r) (f (Suc n)) c) then 1 else 0)"
using tick_count_fsuc[OF assms] card_sing_prop[of "f (Suc n)" "\<lambda>k. hamlet ((Rep_run r) k c)"] by simp

corollary tick_count_f_suc_suc:
  assumes "dilating f sub r"
    shows "tick_count r c (f (Suc n)) = (if hamlet ((Rep_run r) (f (Suc n)) c)
                                       then Suc (tick_count r c (f n))
                                       else tick_count r c (f n))"
using tick_count_f_suc[OF assms] by simp

lemma tick_count_f_suc_sub:
  assumes "dilating f sub r"
    shows "tick_count r c (f (Suc n)) = (if hamlet ((Rep_run sub) (Suc n) c)
                                         then Suc (tick_count r c (f n))
                                         else tick_count r c (f n))"
using tick_count_f_suc_suc[OF assms] assms by (simp add: dilating_def)

lemma tick_count_sub:
  assumes "dilating f sub r"
  shows "tick_count sub c n = tick_count r c (f n)"
proof -
  have "tick_count sub c n = card {i. i \<le> n \<and> hamlet ((Rep_run sub) i c)}"
    using tick_count_def[of "sub" "c" "n"] .
  also have "... = card (image f {i. i \<le> n \<and> hamlet ((Rep_run sub) i c)})"
    using assms dilating_def dilating_injects[OF assms] by (simp add: card_image)
  also have "... = card {i. i \<le> f n \<and> hamlet ((Rep_run r) i c)}"
    using dilated_prefix[OF assms, symmetric, of "n" "c"] by simp
  also have "... = tick_count r c (f n)"
    using tick_count_def[of "r" "c" "f n"] by simp
  finally show ?thesis .
qed

corollary run_tick_count_sub:
  assumes "dilating f sub r"
  shows "run_tick_count sub c n = run_tick_count r c (f n)"
using tick_count_sub[OF assms] tick_count_is_fun by metis

lemma dil_tick_count:
  assumes "sub \<lless> r"
      and "\<forall>n. run_tick_count sub a n \<le> run_tick_count sub b n"
    shows "run_tick_count r a n \<le> run_tick_count r b n"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  show ?thesis
  proof (induction n)
    case 0
    from assms(2) have "tick_count sub a 0 \<le> tick_count sub b 0" using tick_count_is_fun by metis
    hence 1:"tick_count r a (f 0) \<le> tick_count r b (f 0)" using tick_count_sub[OF *] by simp
    from * dilating_def dilating_fun_def have "0 \<le> f 0" by simp
    hence "tick_count r a 0 \<le> tick_count r b 0"
    proof -
      consider (a) "0 < f 0" | (b) "0 = f 0" by linarith thus ?thesis
      proof (cases)
        case a
          from empty_dilated_prefix[OF * this] show ?thesis using tick_count_def[of "r" _ "0"]
          by (metis (mono_tags, lifting) Collect_empty_eq card.empty le_zero_eq) 
      next
        case b thus ?thesis using 1 by simp
      qed
    qed
    thus ?case by (simp add: tick_count_is_fun)
  next
    case (Suc n) 
    from assms(2) have "tick_count sub a (Suc n) \<le> tick_count sub b (Suc n)"
      using tick_count_is_fun by metis
    hence 1:"tick_count r a (f (Suc n)) \<le> tick_count r b (f (Suc n))" using tick_count_sub[OF *] by simp
    thus ?case using assms tick_count_f_suc_sub[OF *] Suc.IH
      by (smt is_subrun_def run_tick_count_sub run_tick_count_suc ticks_imp_ticks_subk)
  qed
qed

lemma tick_count_strict_0:
  assumes "dilating f sub r"
    shows "tick_count_strict r c (f 0) = 0"
by (metis (no_types, lifting) Collect_empty_eq assms card.empty empty_dilated_prefix tick_count_strict_def)

lemma no_tick_before_suc:
  assumes "dilating f sub r"
      and "(f n) < k \<and> k < (f (Suc n))"
    shows "\<not>hamlet ((Rep_run r) k c)"
by (metis assms dilating_def dilating_fun_def not_less_eq strict_mono_less)

lemma tick_count_strict_stable:
  assumes "dilating f sub r"
  assumes "(f n) < k \<and> k < (f (Suc n))"
  shows "tick_count_strict r c k = tick_count_strict r c (f (Suc n))"
proof -
  have "tick_count_strict r c k = card {i. i < k \<and> hamlet ((Rep_run r) i c)}"
    using tick_count_strict_def[of "r" "c" "k"] .
  from assms(2) have "(f n) < k" by simp
  from card_mnm[OF this] have 1:
    "card {i. i < k \<and> hamlet ((Rep_run r) i c)}
   = card {i. i \<le> (f n) \<and> hamlet ((Rep_run r) i c)}
   + card {i. (f n) < i \<and> i < k \<and> hamlet ((Rep_run r) i c)}"
    by simp
  from assms(2) have "k < f (Suc n)" by simp
  with no_tick_before_suc[OF assms(1)] have
    "card {i. (f n) < i \<and> i < k \<and> hamlet ((Rep_run r) i c)} = 0" by fastforce
  with 1 have
    "card {i. i < k \<and> hamlet ((Rep_run r) i c)}
   = card {i. i \<le> (f n) \<and> hamlet ((Rep_run r) i c)}" by linarith
  hence 
    "card {i. i < k \<and> hamlet ((Rep_run r) i c)}
   = card {i. i < (f (Suc n)) \<and> hamlet ((Rep_run r) i c)}"
    using no_tick_before_suc[OF assms(1)] assms(2) by (metis less_trans not_le order_le_less)
  thus ?thesis using tick_count_strict_def[symmetric, of "k" "r" "c"]
                     tick_count_strict_def[symmetric, of "f (Suc n)" "r" "c"] by simp
qed

lemma tick_count_strict_sub:
  assumes "dilating f sub r"
  shows "tick_count_strict sub c n = tick_count_strict r c (f n)"
proof -
  have "tick_count_strict sub c n = card {i. i < n \<and> hamlet ((Rep_run sub) i c)}"
    using tick_count_strict_def[of "sub" "c" "n"] .
  also have "... = card (image f {i. i < n \<and> hamlet ((Rep_run sub) i c)})"
    using assms dilating_def dilating_injects[OF assms] by (simp add: card_image)
  also have "... = card {i. i < f n \<and> hamlet ((Rep_run r) i c)}"
    using dilated_strict_prefix[OF assms, symmetric, of "n" "c"] by simp
  also have "... = tick_count_strict r c (f n)"
    using tick_count_strict_def[of "r" "c" "f n"] by simp
  finally show ?thesis .
qed

lemma card_prop_mono:
  assumes "m \<le> n"
    shows "card {i::nat. i \<le> m \<and> P i} \<le> card {i. i \<le> n \<and> P i}"
proof -
  from assms have "{i. i \<le> m \<and> P i} \<subseteq> {i. i \<le> n \<and> P i}" by auto
  moreover have "finite {i. i \<le> n \<and> P i}" by simp
  ultimately show ?thesis by (simp add: card_mono)
qed

lemma mono_tick_count:
  "mono (\<lambda> k. tick_count r c k)"
proof
  { fix x y::nat
    assume "x \<le> y"
    from card_prop_mono[OF this] have "tick_count r c x \<le> tick_count r c y"
      unfolding tick_count_def by simp
  } thus "\<And>x y. x \<le> y \<Longrightarrow> tick_count r c x \<le> tick_count r c y" .
qed

lemma greatest_prev_image:
  assumes "dilating f sub r"
    shows "(\<nexists>n\<^sub>0. f n\<^sub>0 = n) \<Longrightarrow> (\<exists>n\<^sub>p. f n\<^sub>p < n \<and> (\<forall>k. f n\<^sub>p < k \<and> k \<le> n \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k)))"
proof (induction n)
  case 0
    with assms have "f 0 = 0" by (simp add: dilating_def dilating_fun_def)
    thus ?case using "0.prems" by blast
next
  case (Suc n)
  show ?case
  proof (cases "\<exists>n\<^sub>0. f n\<^sub>0 = n")
    case True
      from this obtain n\<^sub>0 where "f n\<^sub>0 = n" by blast
      hence "f n\<^sub>0 < (Suc n) \<and> (\<forall>k. f n\<^sub>0 < k \<and> k \<le> (Suc n) \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))"
        using Suc.prems Suc_leI le_antisym by blast
      thus ?thesis by blast
  next
    case False
    from Suc.IH[OF this] obtain n\<^sub>p
      where "f n\<^sub>p < n \<and> (\<forall>k. f n\<^sub>p < k \<and> k \<le> n \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))" by blast
    with Suc(2) have "f n\<^sub>p < (Suc n) \<and> (\<forall>k. f n\<^sub>p < k \<and> k \<le> (Suc n) \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))"
      by (metis le_SucE less_Suc_eq)
    thus ?thesis by blast
  qed
qed

lemma strict_mono_suc:
  assumes "strict_mono f"
      and "f sn = Suc (f n)"
    shows "sn = Suc n"
by (metis Suc_lessI assms lessI not_less_eq strict_mono_def strict_mono_less)

lemma tick_count_latest:
  assumes "dilating f sub r"
      and "f n\<^sub>p < n \<and> (\<forall>k. f n\<^sub>p < k \<and> k \<le> n \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))"
    shows "tick_count r c n = tick_count r c (f n\<^sub>p)"
by (smt Collect_cong assms le_trans not_le_imp_less not_less_iff_gr_or_eq tick_count_def ticks_imp_ticks_subk)

lemma next_non_stuttering:
  assumes "dilating f sub r"
      and "f n\<^sub>p < n \<and> (\<forall>k. f n\<^sub>p < k \<and> k \<le> n \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))"
      and "f sn\<^sub>0 = Suc n"
    shows "sn\<^sub>0 = Suc n\<^sub>p"
proof -
  from assms(1) have smf:"strict_mono f" by (simp add: dilating_def dilating_fun_def)
  from assms(2) have "f n\<^sub>p < n" by simp
  with smf assms(3) have *:"sn\<^sub>0 > n\<^sub>p" using strict_mono_less by fastforce
  from assms(2) have "f (Suc n\<^sub>p) > n" by (metis lessI not_le_imp_less smf strict_mono_less)
  hence "Suc n \<le> f (Suc n\<^sub>p)" by simp
  hence "sn\<^sub>0 \<le> Suc n\<^sub>p" using assms(3) smf using strict_mono_less_eq by fastforce
  with * show ?thesis by simp
qed

lemma stutter_no_time:
  assumes "dilating f sub r"
      and "\<forall>k. f n < k \<and> k \<le> m \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k)"
      and "m > f n"
    shows "time ((Rep_run r) m c) = time ((Rep_run r) (f n) c)"
proof -
  from assms have "\<forall>k. f n < k \<and> k \<le> m \<longrightarrow> time ((Rep_run r) k c) = time ((Rep_run r) (f n) c)"
  proof -
  { fix k assume hyp:"f n < k \<and> k \<le> m"
    have "time ((Rep_run r) k c) = time ((Rep_run r) (f n) c)"
    proof (cases "k=0")
      case True
        hence "n = 0" using hyp by blast
        hence "f n = 0" using assms(1) by (simp add: dilating_def dilating_fun_def)
        thus ?thesis by (simp add: True)
    next
      case False
        hence "\<exists>k\<^sub>0. k = Suc k\<^sub>0"  using lessE by blast
        from this obtain k\<^sub>0 where kprop:"k = Suc k\<^sub>0" by blast
        hence "\<nexists>z. f z = Suc k\<^sub>0" using assms(2) hyp by blast
        hence "time ((Rep_run r) k c) = time ((Rep_run r) k\<^sub>0 c)"
          using assms(1) dilating_def dilating_fun_def kprop by blast
      then show ?thesis sorry (* induction needed *)
    qed
  } thus ?thesis by simp
  qed
  thus ?thesis using assms(3) by blast
qed

lemma time_stuttering:
  assumes "dilating f sub r"
      and "time ((Rep_run sub) n c) = \<tau>"
      and "\<forall>k. f n < k \<and> k \<le> m \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k)"
      and "m > f n"
    shows "time ((Rep_run r) m c) = \<tau>"
proof -
  from assms(3) have "time ((Rep_run r) m c) = time ((Rep_run r) (f n) c)"
    using  stutter_no_time[OF assms(1,3,4)] ..
  also from assms(1,2) have "time ((Rep_run r) (f n) c) = \<tau>" by (simp add: dilating_def)
  finally show ?thesis .
qed

lemma first_time_image:
  assumes "dilating f sub r"
  shows "first_time sub c n t = first_time r c (f n) t"
proof
  assume "first_time sub c n t"
  with before_first_time[OF this]
    have *:"time ((Rep_run sub) n c) = t \<and> (\<forall>m < n. time((Rep_run sub) m c) < t)"
      by (simp add: first_time_def)
  hence **:"time ((Rep_run r) (f n) c) = t \<and> (\<forall>m < n. time((Rep_run r) (f m) c) < t)"
    using assms(1) dilating_def by metis
  have "\<forall>m < f n. time ((Rep_run r) m c) < t"
  proof -
  { fix m assume hyp:"m < f n"
    have "time ((Rep_run r) m c) < t"
    proof (cases "\<exists>m\<^sub>0. f m\<^sub>0 = m")
      case True
        from this obtain m\<^sub>0 where mm0:"m = f m\<^sub>0" by blast
        with hyp have m0n:"m\<^sub>0 < n" using assms(1) by (simp add: dilating_def dilating_fun_def strict_mono_less)
        hence "time ((Rep_run sub) m\<^sub>0 c) < t" using * by blast
        thus ?thesis by (simp add: mm0 m0n **)
    next
      case False
        hence "\<exists>m\<^sub>p. f m\<^sub>p < m \<and> (\<forall>k. f m\<^sub>p < k \<and> k \<le> m \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))" using greatest_prev_image[OF assms] by simp
        from this obtain m\<^sub>p where mp:"f m\<^sub>p < m \<and> (\<forall>k. f m\<^sub>p < k \<and> k \<le> m \<longrightarrow> (\<nexists>k\<^sub>0. f k\<^sub>0 = k))" by blast
        hence "time ((Rep_run r) m c) = time ((Rep_run sub) m\<^sub>p c)"  using time_stuttering[OF assms] by blast
        moreover from mp have "time ((Rep_run sub) m\<^sub>p c) < t" using *
          by (meson assms dilating_def dilating_fun_def hyp less_trans strict_mono_less)
        ultimately show ?thesis by simp
      qed
    } thus ?thesis by simp
  qed
  with ** show "first_time r c (f n) t" by (simp add: alt_first_time_def)
next
  assume "first_time r c (f n) t"
  hence *:"time ((Rep_run r) (f n) c) = t \<and> (\<forall>k < f n. time ((Rep_run r) k c) < t)"
    by (simp add: first_time_def before_first_time)
  hence "time ((Rep_run sub) n c) = t" using assms dilating_def by blast
  moreover from * have "(\<forall>k < n. time ((Rep_run sub) k c) < t)"
    using assms dilating_def dilating_fun_def strict_monoD by fastforce
  ultimately show "first_time sub c n t" by (simp add: alt_first_time_def)
qed

end