use NativeCall;
use Git::Error;
use Git::Buffer;

class Git::Patch is repr('CPointer')
{
    sub git_patch_free(Git::Patch)
        is native('git2') {}

    sub git_patch_to_buf(Git::Buffer, Git::Patch --> int32)
        is native('git2') {}

    method Str
    {
        my Git::Buffer $buf .= new;
        check(git_patch_to_buf($buf, self));
        $buf.str
    }

    sub git_patch_get_delta(Git::Patch --> Pointer)
        is native('git2') {}

    method delta
    {
        nativecast(::('Git::Diff::Delta'), git_patch_get_delta(self))
    }

    submethod DESTROY { git_patch_free(self) }
}