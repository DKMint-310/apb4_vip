# Third-party RTL

The verification repository vendors an **unmodified subset** of two upstream
repositories. This is not a fork of their full test infrastructure.

| Directory | Upstream | Fixed revision | License |
|---|---|---|---|
| apb | https://github.com/pulp-platform/apb | 4821618d652cb2b219483f037395b902771a44dd | SHL-0.51 |
| common_cells | https://github.com/pulp-platform/common_cells | 46b3907d9ac97861ab5dee27d177b76530fdd038 (v1.16.2) | SHL-0.51 |

See each directory's LICENSE and the original file copyright headers.
All selected files are copied as raw Git blobs; their SHA-256 digests and source
paths are recorded in `manifest.json`. `python scripts/check_vendor.py` verifies
the local files offline. No upstream verification source is copied as our work.

The common_cells version is the version declared by APB's upstream Bender.yml.
Only addr_decode, cf_math_pkg and the registers macros are needed here.
Full-package dependencies common_verification and tech_cells_generic are not
used by this subset. The copied Bender.yml files document upstream provenance;
they are not the build entry points for this partial snapshot. Use `sim/dut.f`.

The APB source file contains both apb_regs and apb_regs_intf, so APB interface,
package and mapping/type macros are included even when selecting apb_regs.

Keep upstream sources unchanged. Proposed fixes should be separate patches with
reproducers and explicit attribution. Do not edit hashes merely to hide changes.
For an intentional dependency update, review the new revision, regenerate the
manifest from raw source blobs and rerun compilation and functional tests.
