*> \brief \b CTRT02
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*  Definition:
*  ===========
*
*       SUBROUTINE CTRT02( UPLO, TRANS, DIAG, N, NRHS, A, LDA, X, LDX, B,
*                          LDB, WORK, RWORK, RESID )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIAG, TRANS, UPLO
*       INTEGER            LDA, LDB, LDX, N, NRHS
*       REAL               RESID
*       ..
*       .. Array Arguments ..
*       REAL               RWORK( * )
*       COMPLEX            A( LDA, * ), B( LDB, * ), WORK( * ),
*      $                   X( LDX, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CTRT02 computes the residual for the computed solution to a
*> triangular system of linear equations op(A)*X = B, where A is a
*> triangular matrix. The test ratio is the maximum over the number of
*> right hand sides of
*>    norm(op(A)*X - B) / ( norm(op(A)) * norm(X) * EPS ),
*> where op(A) = A, A**T, or A**H, and EPS is the machine epsilon.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] UPLO
*> \verbatim
*>          UPLO is CHARACTER*1
*>          Specifies whether the matrix A is upper or lower triangular.
*>          = 'U':  Upper triangular
*>          = 'L':  Lower triangular
*> \endverbatim
*>
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER*1
*>          Specifies the operation applied to A.
*>          = 'N':  A    * X = B  (No transpose)
*>          = 'T':  A**T * X = B  (Transpose)
*>          = 'C':  A**H * X = B  (Conjugate transpose)
*> \endverbatim
*>
*> \param[in] DIAG
*> \verbatim
*>          DIAG is CHARACTER*1
*>          Specifies whether or not the matrix A is unit triangular.
*>          = 'N':  Non-unit triangular
*>          = 'U':  Unit triangular
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The order of the matrix A.  N >= 0.
*> \endverbatim
*>
*> \param[in] NRHS
*> \verbatim
*>          NRHS is INTEGER
*>          The number of right hand sides, i.e., the number of columns
*>          of the matrices X and B.  NRHS >= 0.
*> \endverbatim
*>
*> \param[in] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          The triangular matrix A.  If UPLO = 'U', the leading n by n
*>          upper triangular part of the array A contains the upper
*>          triangular matrix, and the strictly lower triangular part of
*>          A is not referenced.  If UPLO = 'L', the leading n by n lower
*>          triangular part of the array A contains the lower triangular
*>          matrix, and the strictly upper triangular part of A is not
*>          referenced.  If DIAG = 'U', the diagonal elements of A are
*>          also not referenced and are assumed to be 1.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,N).
*> \endverbatim
*>
*> \param[in] X
*> \verbatim
*>          X is COMPLEX array, dimension (LDX,NRHS)
*>          The computed solution vectors for the system of linear
*>          equations.
*> \endverbatim
*>
*> \param[in] LDX
*> \verbatim
*>          LDX is INTEGER
*>          The leading dimension of the array X.  LDX >= max(1,N).
*> \endverbatim
*>
*> \param[in] B
*> \verbatim
*>          B is COMPLEX array, dimension (LDB,NRHS)
*>          The right hand side vectors for the system of linear
*>          equations.
*> \endverbatim
*>
*> \param[in] LDB
*> \verbatim
*>          LDB is INTEGER
*>          The leading dimension of the array B.  LDB >= max(1,N).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (N)
*> \endverbatim
*>
*> \param[out] RWORK
*> \verbatim
*>          RWORK is REAL array, dimension (N)
*> \endverbatim
*>
*> \param[out] RESID
*> \verbatim
*>          RESID is REAL
*>          The maximum over the number of right hand sides of
*>          norm(op(A)*X - B) / ( norm(op(A)) * norm(X) * EPS ).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \ingroup complex_lin
*
*  =====================================================================
      SUBROUTINE CTRT02( UPLO, TRANS, DIAG, N, NRHS, A, LDA, X, LDX, B,
     $                   LDB, WORK, RWORK, RESID )
*
*  -- LAPACK test routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
*     .. Scalar Arguments ..
      CHARACTER          DIAG, TRANS, UPLO
      INTEGER            LDA, LDB, LDX, N, NRHS
      REAL               RESID
*     ..
*     .. Array Arguments ..
      REAL               RWORK( * )
      COMPLEX            A( LDA, * ), B( LDB, * ), WORK( * ),
     $                   X( LDX, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO, ONE
      PARAMETER          ( ZERO = 0.0E+0, ONE = 1.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            J
      REAL               ANORM, BNORM, EPS, XNORM
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      REAL               CLANTR, SCASUM, SLAMCH
      EXTERNAL           LSAME, CLANTR, SCASUM, SLAMCH
*     ..
*     .. External Subroutines ..
      EXTERNAL           CAXPY, CCOPY, CTRMV
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CMPLX, MAX
*     ..
*     .. Executable Statements ..
*
*     Quick exit if N = 0 or NRHS = 0
*
      IF( N.LE.0 .OR. NRHS.LE.0 ) THEN
         RESID = ZERO
         RETURN
      END IF
*
*     Compute the 1-norm of op(A).
*
      IF( LSAME( TRANS, 'N' ) ) THEN
         ANORM = CLANTR( '1', UPLO, DIAG, N, N, A, LDA, RWORK )
      ELSE
         ANORM = CLANTR( 'I', UPLO, DIAG, N, N, A, LDA, RWORK )
      END IF
*
*     Exit with RESID = 1/EPS if ANORM = 0.
*
      EPS = SLAMCH( 'Epsilon' )
      IF( ANORM.LE.ZERO ) THEN
         RESID = ONE / EPS
         RETURN
      END IF
*
*     Compute the maximum over the number of right hand sides of
*        norm(op(A)*X - B) / ( norm(op(A)) * norm(X) * EPS )
*
      RESID = ZERO
      DO 10 J = 1, NRHS
         CALL CCOPY( N, X( 1, J ), 1, WORK, 1 )
         CALL CTRMV( UPLO, TRANS, DIAG, N, A, LDA, WORK, 1 )
         CALL CAXPY( N, CMPLX( -ONE ), B( 1, J ), 1, WORK, 1 )
         BNORM = SCASUM( N, WORK, 1 )
         XNORM = SCASUM( N, X( 1, J ), 1 )
         IF( XNORM.LE.ZERO ) THEN
            RESID = ONE / EPS
         ELSE
            RESID = MAX( RESID, ( ( BNORM / ANORM ) / XNORM ) / EPS )
         END IF
   10 CONTINUE
*
      RETURN
*
*     End of CTRT02
*
      END
