#include <linux/sched.h>
#include <linux/file.h>
#include <linux/fdtable.h>
#include <linux/atomic.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/spinlock.h>
#include <linux/kallsyms.h>
#include <linux/version.h>

static void (*mmput_async_ptr)(struct mm_struct *mm) = NULL;
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 11, 0)
static void (*zap_page_range_ptr)(struct vm_area_struct *, unsigned long, unsigned long) = NULL;
#else
static void (*zap_page_range_ptr)(struct vm_area_struct *, unsigned long, unsigned long, struct zap_details *) = NULL;
#endif
static int (*__close_fd_get_file_ptr)(unsigned int fd, struct file **res) = NULL;
static int (*can_nice_ptr)(const struct task_struct *, const int) = NULL;
static int (*security_binder_set_context_mgr_ptr)(struct task_struct *mgr) = NULL;
static int (*security_binder_transaction_ptr)(struct task_struct *from, struct task_struct *to) = NULL;
static int (*security_binder_transfer_binder_ptr)(struct task_struct *from, struct task_struct *to) = NULL;
static int (*security_binder_transfer_file_ptr)(struct task_struct *from, struct task_struct *to, struct file *file) = NULL;
static int (*task_work_add_ptr)(struct task_struct *task, struct callback_head *work, bool notify) = NULL;

void mmput_async(struct mm_struct *mm)
{
	if (!mmput_async_ptr)
		mmput_async_ptr = kallsyms_lookup_name("mmput_async");
	return mmput_async_ptr(mm);
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 11, 0)
void zap_page_range(struct vm_area_struct *vma, unsigned long address, unsigned long size)
#else
void zap_page_range(struct vm_area_struct *vma, unsigned long address, unsigned long size, struct zap_details *details)
#endif
{
	if (!zap_page_range_ptr)
		zap_page_range_ptr = kallsyms_lookup_name("zap_page_range");
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 11, 0)
	zap_page_range_ptr(vma, address, size);
#else
	zap_page_range_ptr(vma, address, size, details);
#endif
}

int __close_fd_get_file(unsigned int fd, struct file **res)
{
	if (!__close_fd_get_file_ptr)
		__close_fd_get_file_ptr = kallsyms_lookup_name("__close_fd_get_file");
	return __close_fd_get_file_ptr(fd, res);
}

int can_nice(const struct task_struct *p, const int nice)
{
	if (!can_nice_ptr)
		can_nice_ptr = kallsyms_lookup_name("can_nice");
	return can_nice_ptr(p, nice);
}

int security_binder_set_context_mgr(struct task_struct *mgr)
{
	if (!security_binder_set_context_mgr_ptr)
		security_binder_set_context_mgr_ptr = kallsyms_lookup_name("security_binder_set_context_mgr");
	return security_binder_set_context_mgr_ptr(mgr);
}

int security_binder_transaction(struct task_struct *from, struct task_struct *to)
{
	if (!security_binder_transaction_ptr)
		security_binder_transaction_ptr = kallsyms_lookup_name("security_binder_transaction");
	return security_binder_transaction_ptr(from, to);
}

int security_binder_transfer_binder(struct task_struct *from, struct task_struct *to)
{
	if (!security_binder_transfer_binder_ptr)
		security_binder_transfer_binder_ptr = kallsyms_lookup_name("security_binder_transfer_binder");
	return security_binder_transfer_binder_ptr(from, to);
}

int security_binder_transfer_file(struct task_struct *from, struct task_struct *to, struct file *file)
{
	if (!security_binder_transfer_file_ptr)
		security_binder_transfer_file_ptr = kallsyms_lookup_name("security_binder_transfer_file");
	return security_binder_transfer_file_ptr(from, to, file);
}

int task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
{
	if (!task_work_add_ptr)
		task_work_add_ptr = kallsyms_lookup_name("task_work_add");
	return task_work_add_ptr(task, work, notify);
}
